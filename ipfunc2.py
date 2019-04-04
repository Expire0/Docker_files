#!/usr/bin/env python3
import socket
from pg import DB
import mysql.connector as dbconnect
import subprocess
import datetime
import sys

from binascii import hexlify as clean
da = "884"

db_user="findnets"
db_pass="nmaULvTY-2.02.05"

nuser="natprovtools"
npass="ad9RdG3"
argv1=""
myDate = datetime.date.today().strftime("%Y%m%d")

mas = DB(host='10.146.25.8',dbname='iputil',user=db_user ,passwd=db_pass)

validate = [b'9488899485a2f0f1f8f8f4', b'9599a4a2a285f2f0f2f8f8f4', b'a391818392a2f3f6f3f8f8f4', b'94a6819393a2f2f0f0f8f8f4', b'a68388899384f2f0f0f8f8f4', b'949481a381a2f0f0f183f8f8f4', b'8394838796a5f0f0f0f8f8f4', b'858896939485f0f0f3f8f8f4', b'9497858199a2f0f0f8f8f4', b'9599859596f0f0f1f8f8f4', b'a69481878585f2f0f1f8f8f4', b'88a28885a3a3f0f0f283f8f8f4', b'a29481a2a281f2f0f0f8f8f4', b'a68396a3a396f2f0f0f8f8f4']


def auth1(user):

    dippval = user + da
    check0 = dippval.encode("cp037")
    co = clean(check0)
    if co in validate:
        print("NT ID validated")
    else:
        print("Please use a valid NT ID")
        sys.exit()


def activate(argv1):
    try:
        socket.inet_pton(socket.AF_INET6,argv1)
        check = mas.query("SELECT prov_group.name, fqdn FROM prefix LEFT JOIN prov_group USING (prov_group_id) LEFT JOIN dns ON prefix.primary_subnet = dns.primary_subnet WHERE '%s' <<= address LIMIT 1" % (argv1))
        result = check.getresult()
        pg, fqdn = zip(*result)
        print(pg[0])
        comm = "/opt/nwreg2/local/usrbin/nrcmd -C %s-pdhcp -N %s -P %s lease6 %s activate" % (pg[0],nuser,npass,argv1)
        comm1= "/opt/nwreg2/local/usrbin/nrcmd -C %s-sdhcp -N %s -P %s lease6 %s activate" % (pg[0],nuser,npass,argv1)
        comm2 = "/opt/nwreg2/local/usrbin/nrcmd -C %s-pdhcp -N %s -P %s lease6 %s force-available" % (pg[0],nuser,npass,argv1)
        comm3= "/opt/nwreg2/local/usrbin/nrcmd -C %s-sdhcp -N %s -P %s lease6 %s force-available" % (pg[0],nuser,npass,argv1)
  
        subprocess.call(comm, shell=True)
        subprocess.call(comm1, shell=True)
        subprocess.call(comm2, shell=True)
        subprocess.call(comm3, shell=True)


        # remove from  local db 
        dippdb = dbconnect.connect(user='root', password='cray74_tats',host='localhost',database='ip_deact' )
        data = dippdb.cursor()
        query =("delete from ip where ip='%s';" % (argv1))
        data.execute(query)
        dippdb.commit()
        print("<br>" + argv1 + " has been removed from the local database and activated in CPNR PG " + pg[0])


    except socket.error:
        pass

    try:
        socket.inet_aton(argv1)
        check=mas.query("SELECT prov_group.name, fqdn FROM scope LEFT JOIN prov_group USING (prov_group_id) LEFT JOIN dns ON scope.primary_subnet = dns.primary_subnet WHERE '%s' <<= subnet LIMIT 1" % (argv1))
        result = check.getresult()
        pg, fqdn = zip(*result)
        #print(pg[0])
        #print(fqdn[0])
        comm = "/opt/nwreg2/local/usrbin/nrcmd -C %s-pdhcp -N %s -P %s lease %s activate" % (pg[0],nuser,npass,argv1)    
        comm1= "/opt/nwreg2/local/usrbin/nrcmd -C %s-sdhcp -N %s -P %s lease %s activate" % (pg[0],nuser,npass,argv1)
        comm2 = "/opt/nwreg2/local/usrbin/nrcmd -C %s-pdhcp -N %s -P %s lease %s force-available" % (pg[0],nuser,npass,argv1)
        comm3= "/opt/nwreg2/local/usrbin/nrcmd -C %s-sdhcp -N %s -P %s lease %s force-available" % (pg[0],nuser,npass,argv1)

        subprocess.call(comm, shell=True)
        subprocess.call(comm1, shell=True)
        subprocess.call(comm2, shell=True)
        subprocess.call(comm3, shell=True)        


        # The below is for debugging only and should be commented
        #print("<br>" + comm)
        #print("<br>" + comm1)
        #print("<br>" + comm2)
        #print("<br>" + comm3)
        

        # remove from  local db 
        dippdb = dbconnect.connect(user='root', password='cray74_tats',host='localhost',database='ip_deact' )
        data = dippdb.cursor()
        query =("delete from ip where ip='%s';" % (argv1))
        data.execute(query)
        dippdb.commit()
        print("<br>" + argv1 + " has been removed from the local database and activated in CPNR PG " + pg[0])        



    except socket.error:
        pass

def deactivate(argv1,user):
    try:
        socket.inet_pton(socket.AF_INET6,argv1)
        check = mas.query("SELECT prov_group.name, fqdn FROM prefix LEFT JOIN prov_group USING (prov_group_id) LEFT JOIN dns ON prefix.primary_subnet = dns.primary_subnet WHERE '%s' <<= address LIMIT 1 " % (argv1))
        result = check.getresult()
        pg, fqdn = zip(*result)
        print(pg[0])
        comm = "/opt/nwreg2/local/usrbin/nrcmd -C %s-pdhcp -N %s -P %s lease6 %s deactivate" % (pg[0],nuser,npass,argv1)
        comm1= "/opt/nwreg2/local/usrbin/nrcmd -C %s-sdhcp -N %s -P %s lease6 %s deactivate" % (pg[0],nuser,npass,argv1)
        #disabled to keep the binding v6 lease in the db- we will remove fro dhcp during activation
#        comm2 = "/opt/nwreg2/local/usrbin/nrcmd -C %s-pdhcp -N %s -P %s lease6 %s force-available" % (pg[0],nuser,npass,argv1)
#        comm3= "/opt/nwreg2/local/usrbin/nrcmd -C %s-sdhcp -N %s -P %s lease6 %s force-available" % (pg[0],nuser,npass,argv1)
   
        subprocess.call(comm, shell=True)
        subprocess.call(comm1, shell=True)
#        subprocess.call(comm2, shell=True)
#        subprocess.call(comm3, shell=True)
         
        # insert into   local db 
        dippdb = dbconnect.connect(user='root', password='cray74_tats',host='localhost',database='ip_deact' )
        data = dippdb.cursor()
        query =("insert into ip (ip,user,date) VALUES ('%s','%s','%s')" % (argv1,user,myDate))
        data.execute(query)
        dippdb.commit()
        print("<br>" + argv1 + " has been removed from the local database and deactivated in CPNR PG " + pg[0])

    except socket.error:
        pass

    try:
        socket.inet_aton(argv1)
        check=mas.query("SELECT prov_group.name, fqdn FROM scope LEFT JOIN prov_group USING (prov_group_id) LEFT JOIN dns ON scope.primary_subnet = dns.primary_subnet WHERE '%s' <<= subnet LIMIT 1" % (argv1))
        result = check.getresult()
        pg, fqdn = zip(*result)
        #print(pg[0])
        #print(fqdn[0])
        comm = "/opt/nwreg2/local/usrbin/nrcmd -C %s-pdhcp -N %s -P %s lease %s deactivate" % (pg[0],nuser,npass,argv1)
        comm1= "/opt/nwreg2/local/usrbin/nrcmd -C %s-sdhcp -N %s -P %s lease %s deactivate" % (pg[0],nuser,npass,argv1)
        comm2 = "/opt/nwreg2/local/usrbin/nrcmd -C %s-pdhcp -N %s -P %s lease %s force-available" % (pg[0],nuser,npass,argv1)
        comm3= "/opt/nwreg2/local/usrbin/nrcmd -C %s-sdhcp -N %s -P %s lease %s force-available" % (pg[0],nuser,npass,argv1)

        subprocess.call(comm, shell=True)
        subprocess.call(comm1, shell=True)
        subprocess.call(comm2, shell=True)
        subprocess.call(comm3, shell=True)


        # The below is for debugging only and should be commented
        #print("<br>" + comm)
        #print("<br>" + comm1)
        #print("<br>" + comm2)
        #print("<br>" + comm3)
    

        # insert into   local db 
        dippdb = dbconnect.connect(user='root', password='cray74_tats',host='localhost',database='ip_deact' )
        data = dippdb.cursor()
        query =("insert into ip (ip,user,date) VALUES ('%s','%s','%s')" % (argv1,user,myDate))
        data.execute(query)
        dippdb.commit()
        print("<br>" + argv1 + " has been removed from the local database and activated in CPNR PG " + pg[0])



    except socket.error:
        pass


def localcheck():
    # connect to local db 
    dippdb = dbconnect.connect(user='root', password='cray74_tats',host='localhost',database='ip_deact' )
    data = dippdb.cursor()
    query =("select ip,user,date from ip")
    data.execute(query)
    print("<ul>")
    for lease in data:
        print("<li> Lease " +  lease[0] + " || <b> Deactivated by </b> " + lease[1] + " on " )
        print(lease[2])
        print("</li>")
        print("</br>")
    print("</ul>")
