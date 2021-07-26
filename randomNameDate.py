import names 
import random
import time

def str_time_prop(start, end, time_format, prop):

    stime = time.mktime(time.strptime(start, time_format))
    etime = time.mktime(time.strptime(end, time_format))

    ptime = stime + prop * (etime - stime)

    return time.strftime(time_format, time.localtime(ptime))


def random_date(start, end, prop):
    return str_time_prop(start, end, '%Y-%m-%d %I:%M:%S', prop)
	
for i in range(0,100):
    s = names.get_full_name()
    s = s.replace(" ","_")
    d = random_date("2020-1-1 1:30:60", "2020-4-1 4:50:60", random.random())
    print("('",s,"', CONVERT(datetime,'",d,"',120)),")