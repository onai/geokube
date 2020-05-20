import os
import glob
import re


for fil in glob.glob('logs/*'):
    print("latency for ", fil ," at ",os.path.getmtime(fil))
    #txt = open(fil,'r').readlines()
    pattern = re.compile("(^rtt)(.*)/(.*)/(.*)/(.*)")

    for i, line in enumerate(open(fil))
        result = re.search("(^rtt)(.*)/(.*)/(.*)/(.*)", t)
        avg = result.group(3)

    #awk -F'/' '{ print (/^rtt/? ""$5" ms":"") }' $fil
