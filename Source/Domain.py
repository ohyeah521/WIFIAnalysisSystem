import pyspark
import pymongo
from pyspark.streaming import StreamingContext
import json
import time
import datetime
import sys
import os


def init(x: dict) -> tuple:
    #  将asciitime"Tue Dec 11 18:07:14 2018" --> "2018-12-11 18:07:14"
    x['time'] = time.strftime("%Y-%m-%d %H:%M:%S", time.strptime(x['time'], "%a %b %d %H:%M:%S %Y"))
    #  过滤噪音
    for mac in x['data']:
        if int(mac['range']) > 1000:
            x['data'].remove(mac)
    return x['id'], [x]


def time_difference(date1: str, date2: str) -> datetime.timedelta:
    if date1 == '':
        return datetime.timedelta(seconds=0)
    if date2 == '':
        return datetime.timedelta(seconds=0)
    # 2017-03-28 05:15:12 --> Tue Mar 28 05:15:12 2017 --> time.struct_time
    date1 = time.strptime(time.strftime("%a %b %d %H:%M:%S %Y", time.strptime(date1, "%Y-%m-%d %H:%M:%S")),
                          "%a %b %d ""%H:%M:%S ""%Y")
    date2 = time.strptime(time.strftime("%a %b %d %H:%M:%S %Y", time.strptime(date2, "%Y-%m-%d %H:%M:%S")),
                          "%a %b %d %H:%M:%S %Y")
    date1 = datetime.datetime(date1[0], date1[1], date1[2], date1[3], date1[4], date1[5])
    date2 = datetime.datetime(date2[0], date2[1], date2[2], date2[3], date2[4], date2[5])
    return date2 - date1


def init_mac_list(customer_status_list, now_time):
    mac_list = []  # 待更新的customer信息
    for customer in customer_status_list:
        if customer['status'] == 2:  # 当前在店内
            first_records = [dict(in_time=customer['in_time'], out_time=now_time,
                                  stay_time=str(time_difference(customer["in_time"], now_time)))]
        else:
            first_records = []
        mac_list.append(dict(mac=customer['mac'], status=customer['status'], records=first_records))
    return mac_list


def binary_search(a: list, m: dict) -> tuple:
    low = 0
    high = len(a) - 1
    while low <= high:
        mid = (low + high) // 2
        mid_val = a[mid]
        if mid_val['mac'] < m:
            low = mid + 1
        elif mid_val['mac'] > m:
            high = mid - 1
        else:
            return mid_val, mid
    return 0, -1


def position(mac_data: dict, shop_radius: str) -> bool:
    if int(mac_data['range']) < int(shop_radius):
        return True
    else:
        return False


def read_from_mongodb(mac, shop_id, client):
    try:
        data = client.wifiAnalysis.shop.find_one(dict(mmac=mac, ID=shop_id), dict(customerlist=1, radius=1))
        return data['customerlist'], data['radius']
    except Exception as e:
        print(e)
        return [], 0


def write_for_mongodb(in_area_num, in_shop_num, out_area_num, out_shop_num,
                      shop_information, customer_status_list, mac_list, client):
    shop_ID = shop_information["id"]
    shop_mac = shop_information["mmac"]
    db = client.wifiAnalysis
    analysis = dict(in_area=in_area_num, in_shop=in_shop_num, out_shop=out_shop_num, out_area=out_area_num)
    db.shop.update(dict(ID=shop_ID, mmac=shop_mac),
                   {"$set": dict(customerlist=customer_status_list, total_count=len(customer_status_list),
                                 lat=shop_information["lat"], lon=shop_information["lon"])})

    # customer表
    for mac in mac_list:
        data = db.customer.find_one(dict(mac=mac["mac"], shop_mac=shop_mac))
        if data:
            cycle = data["cycle"]
            records = data["records"]
            if not data["records"]:
                records = mac["records"]
            elif mac["records"]:
                if records[-1]["in_time"] == mac["records"][0]["in_time"]:
                    records[-1] = mac["records"][0]
                    del mac["records"][0]
                    records += mac["records"]
                else:
                    records += mac["records"]
            new_records = []
            for res in records:
                if time_difference(res["in_time"], res["out_time"]) > datetime.timedelta(seconds=3):
                    new_records.append(res)
                elif mac["status"] == 2 and res == mac["records"][-1]:
                    new_records.append(res)
            if len(new_records) >= 2:
                cycle = str(time_difference(new_records[-2]["out_time"], new_records[-1]["in_time"]))
            db.customer.update(dict(mac=mac["mac"], shop_mac=shop_mac),
                               {"$set": dict(records=new_records, total_count=len(new_records), status=mac["status"],
                                             cycle=cycle)})
        else:
            new_records = []
            for res in mac["records"]:
                if time_difference(res["in_time"], res["out_time"]) > datetime.timedelta(seconds=3):
                    new_records.append(res)
                elif mac["status"] == 2 and res == mac["records"][-1]:
                    new_records.append(res)
            cycle = ""
            if len(new_records) >= 2:
                cycle = str(time_difference(new_records[-2]["out_time"], new_records[-1]["in_time"]))
                # cycle = mac["records"][-1]["in_time"] - mac["records"][-2]["out_time"]
            db.customer.insert(dict(mac=mac["mac"], total_count=len(new_records), status=mac["status"], cycle=cycle,
                                    shop_mac=shop_mac, records=new_records))

    # hourly表
    # shop_time = "2018-12-11 18:07:14"
    date1 = time.strptime(time.strftime("%a %b %d %H:%M:%S %Y",
                                        time.strptime(shop_information["time"], "%Y-%m-%d %H:%M:%S")),
                          "%a %b %d %H:%M:%S %Y")
    day = shop_information["time"].split(" ")[0]
    data = db.hourly.find_one(dict(ID=shop_ID, mmac=shop_mac, day=day, hour=str(date1[3])))
    tm_min = str(date1[4])
    if data:
        flow = data["flow"]
        if tm_min in flow["metrics"]:
            for key in flow["metrics"][tm_min]:
                flow["metrics"][tm_min][key] += analysis[key]
        else:
            flow["metrics"][tm_min] = {}
            for key in analysis:
                flow["metrics"][tm_min][key] = analysis[key]
        for key in flow["total"]:
            flow["total"][key] += analysis[key]
        db.hourly.update(dict(ID=shop_ID, mmac=shop_mac, day=day, hour=str(date1[3])), {"$set": dict(flow=flow)})
    else:
        db.hourly.insert(dict(ID=shop_ID, mmac=shop_mac, day=day, hour=str(date1[3]), flow={
            "metrics": {
                tm_min: analysis
            },
            "total": analysis
        }))

    # dayly表
    data = db.dayly.find_one(dict(ID=shop_ID, mmac=shop_mac, day=day))
    tm_hour = str(date1[3])
    if data:
        flow = data["flow"]
        if tm_hour in flow["metrics"]:
            for key in flow["metrics"][tm_hour]:
                flow["metrics"][tm_hour][key] += analysis[key]
        else:
            flow["metrics"][tm_hour] = {}
            for key in analysis:
                flow["metrics"][tm_hour][key] = analysis[key]
        for key in flow["total"]:
            flow["total"][key] += analysis[key]
        db.dayly.update(dict(ID=shop_ID, mmac=shop_mac, day=day),
                        {"$set": dict(flow=flow)})
    else:
        db.dayly.insert(dict(ID=shop_ID, mmac=shop_mac, day=day, wday=str(date1[6]),
                             flow=dict(metrics={tm_hour: analysis}, total=analysis)))


def cal(x):
    # 1 min 前该店探针采集区域所有mac状态信息
    client = pymongo.MongoClient(host='localhost', port=27017)
    shop_data = read_from_mongodb(x[0]['mmac'], x[0]['id'], client)
    shop_radius = shop_data[1]
    shop_information = x[-1].copy()
    shop_information.pop("data")
    shop_time = x[0]['time']
    customer_status_list = sorted(shop_data[0], key=lambda m: m['mac'])
    # 无该店铺信息，不予处理数据
    if customer_status_list == 0:
        return None
    # 计算
    mac_list = init_mac_list(customer_status_list, shop_time)  # 待更新的customer信息
    in_shop_num = 0  # 新入店人数
    out_shop_num = 0  # 新出店人数
    in_area_num = 0  # 新入区域人数
    out_area_num = 0  # 新出区域人数
    for index in range(0, len(x)):
        # area_list = sorted(x[index]['data'], key=lambda m: m['mac'])
        area_list = [x for x in sorted(x[index]['data'], key=lambda m: m['mac']) if
                     int(x["range"]) <= int(shop_radius) + 100]
        for customer in customer_status_list:
            mac_data = binary_search(area_list, customer['mac'])
            if mac_data[0]:  # 在区域内
                if position(mac_data[0], shop_radius):  # 在店铺内
                    if customer["status"] != 2:  # 之前不在店铺, 新入店时刻
                        in_shop_num += 1
                        mac_index = binary_search(mac_list, customer['mac'])
                        if mac_index[0]:  # 如果有过记录
                            mac_list[mac_index[1]]["status"] = 2
                            customer["status"] = 2
                            customer["in_time"] = x[index]['time']
                            customer["stay_time"] = str(time_difference(x[index]['time'], x[index]['time']))
                            mac_list[mac_index[1]]['records'].append(
                                dict(in_time=x[index]['time'], out_time=x[index]['time'],
                                     stay_time=str(time_difference(x[index]['time'], x[index]['time']))))
                        else:  # 如果没有过记录
                            customer["status"] = 2
                            customer["in_time"] = x[index]['time']
                            customer["stay_time"] = str(time_difference(x[index]['time'], x[index]['time']))
                            mac_list.append(dict(mac=customer['mac'], status=2, records=[
                                dict(in_time=x[index]['time'], out_time=x[index]['time'],
                                     stay_time=str(time_difference(x[index]['time'], x[index]['time'])))]))
                    elif customer["status"] == 2:  # 之前就在店铺
                        mac_index = binary_search(mac_list, customer['mac'])
                        if mac_index[0] and len(mac_list[mac_index[1]]['records']):  # 如果有过记录
                            in_time = mac_list[mac_index[1]]['records'][-1]["in_time"]
                            mac_list[mac_index[1]]['records'][-1]["out_time"] = x[index]["time"]
                            mac_list[mac_index[1]]['records'][-1]["stay_time"] = str(time_difference(in_time,
                                                                                                     x[index]['time']))
                            customer["stay_time"] = str(time_difference(in_time, x[index]['time']))
                else:  # 不在店铺内
                    if customer["status"] == 1:  # 之前不在店铺，不用管~~
                        pass
                    else:  # 之前在店铺, 出店时刻
                        customer["status"] = 1
                        customer["in_time"] = ""
                        customer["stay_time"] = ""
                        out_shop_num += 1
                        mac_index = binary_search(mac_list, customer['mac'])
                        if mac_index[0]:  # 如果有过记录
                            mac_list[mac_index[1]]["status"] = 1  # 现在状态为在区域
                            mac_list[mac_index[1]]['records'][-1]["out_time"] = x[index]['time']
                            stay_time = time_difference(mac_list[mac_index[1]]['records'][-1]["in_time"],
                                                        x[index]['time'])
                            mac_list[mac_index[1]]['records'][-1]["stay_time"] = str(stay_time)
                            if datetime.timedelta(seconds=3) >= stay_time:
                                mac_list[mac_index[1]]['records'].pop()
                                out_shop_num -= 1
                                in_shop_num -= 1
                        else:  # 如果没有过记录,没用
                            pass
                area_list.remove(mac_data[0])  # remove for area_list
            else:  # 脱离区域了
                out_area_num += 1
                if customer["status"] == 1:  # 如果是从区域脱离，remove for customer_status_list
                    mac_index = binary_search(mac_list, customer['mac'])
                    if mac_index[0]:  # 如果有过记录
                        mac_list[mac_index[1]]["status"] = 0  # 状态为不在采集区域
                    customer_status_list.remove(customer)
                else:  # 如果是从店里直接脱离，out_time 更新，一次入店记录
                    out_shop_num += 1
                    mac_index = binary_search(mac_list, customer['mac'])
                    if mac_index[0]:  # 如果有过记录
                        mac_list[mac_index[1]]["status"] = 0  # 状态为不在采集区域
                        if len(mac_list[mac_index[1]]['records']):
                            mac_list[mac_index[1]]['records'][-1]["out_time"] = x[index]['time']
                            stay_time = time_difference(mac_list[mac_index[1]]['records'][-1]["in_time"],
                                                        x[index]['time'])
                            mac_list[mac_index[1]]['records'][-1]["stay_time"] = str(stay_time)
                            if datetime.timedelta(seconds=3) >= stay_time:
                                mac_list[mac_index[1]]['records'].pop()
                                out_shop_num -= 1
                                in_shop_num -= 1
                    else:  # 如果没有过记录,没用
                        pass
                    customer_status_list.remove(customer)
        for customer in area_list:
            in_area_num += 1  # 进入区域数++
            status = 1
            if position(customer, shop_radius):  # 如果定位在店内，入店数++, 新入店一枚~~
                in_shop_num += 1
                status += 1
                mac_index = binary_search(mac_list, customer['mac'])
                if mac_index[0]:  # 如果有过记录
                    mac_list[mac_index[1]]["status"] = status
                    mac_list[mac_index[1]]['records'].append(dict(in_time=x[index]['time'], out_time=x[index]['time'],
                                                                  stay_time=str(time_difference(x[index]['time'],
                                                                                                x[index]['time']))))
                else:  # 如果没有过记录
                    mac_list.append(dict(mac=customer['mac'], status=status,
                                         records=[dict(in_time=x[index]['time'], out_time=x[index]['time'],
                                                       stay_time=str(
                                                           time_difference(x[index]['time'], x[index]['time'])))]))
            customer_status_list.append(
                dict(mac=customer['mac'], status=status, in_time=x[index]['time'], stay_time=""))
    # 更新数据库
    write_for_mongodb(in_area_num, in_shop_num, out_area_num, out_shop_num,
                      shop_information, customer_status_list, mac_list, client)


def start(file):
    # create spark application
    conf = pyspark.SparkConf().setAppName("wifiAnalysis")
    sc = pyspark.SparkContext(conf=conf)
    ssc = StreamingContext(sc, 60)
    lines = ssc.textFileStream(file)
    datas = lines.map(lambda x: json.loads(x)) \
        .map(init) \
        .reduceByKey(lambda x, y: x + y) \
        .map(lambda x: sorted(x[1], key=lambda m: m['time'])) \
        .map(cal)

    datas.pprint()
    ssc.start()
    ssc.awaitTermination()


if __name__ == "__main__":
    PYSPARK_PYTHON = "/home/home/hadoop/anaconda3/bin/python"
    os.environ["PYSPARK_PYTHON"] = PYSPARK_PYTHON
    file_path = "hdfs:/wifiAnalysisInput/"
    start(file_path)
