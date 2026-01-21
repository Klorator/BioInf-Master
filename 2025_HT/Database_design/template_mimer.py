import getpass

import mimerpy
from sshtunnel import SSHTunnel

group_name = "ht25_2_1dl301_group_35"
group_password = "pasSWd_35"


def program(mydb):
    mycursor = mydb.cursor()
    mycursor.execute(
        "SELECT table_name FROM information_schema.tables "
        "WHERE table_type = 'BASE TABLE' AND table_schema = '{}'".format(group_name)
    )
    for x in mycursor:
        print(x)

    mycursor.close()


def db_connect():
    mydb = mimerpy.connect(dsn="DBIP22024", user=group_name, password=group_password)

    program(mydb)

    mydb.close()


if __name__ == "__main__":
    ssh_username = input("Enter your Studium username: ")
    ssh_password = getpass.getpass("Enter your Studium password A: ")

    tunnel = SSHTunnel(ssh_username, ssh_password, "groucho.it.uu.se", 22)
    tunnel.start(
        local_host="127.0.0.1",
        local_port=13600,
        remote_host="127.0.0.1",
        remote_port=1360,
    )

    # Now the tunnel is ready, connect to DB
    db_connect()

    # Stop the tunnel
    tunnel.stop()
