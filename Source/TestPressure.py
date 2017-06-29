import pyhdfs
import datetime
import json


def dateRange(start, end, step=1, format="%Y-%m-%d"):
    strptime, strftime = datetime.datetime.strptime, datetime.datetime.strftime
    days = (strptime(end, format) - strptime(start, format)).days
    return [strftime(strptime(start, format) + datetime.timedelta(i), format) for i in range(0, days, step)]


def hourRange(day):
    return [day + "-" + str(x) + "-" for x in range(0, 24)]


if __name__ == '__main__':
    client = pyhdfs.HdfsClient(hosts='localhost:50070')
    start = "2016-12-25"
    end = "2016-12-26"
    f = open("000002", encoding="utf-8")
    data = json.load(f)
    s = [hourRange(day) for day in dateRange(start, end)]
    print(len(s))
    for day in s:
        for hour in day:
            for i in range(0, 60):
                temp = ""
                if i < 10:
                    temp = "0" + str(i)
                else:
                    temp = str(i)
                shop_time = hour + temp
                d = data.pop()
                d["time"] = shop_time
                new_data = []
                for i in range(0, 1000):
                    d["mmac"] = d["mmac"] + str(i)
                    d["id"] = d["id"] + str(i)
                    new_data.append(d)
                file_path = "hdfs:/Text/"
                client.create(file_path + shop_time, new_data)
