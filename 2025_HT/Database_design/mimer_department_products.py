import getpass

import mimerpy
from sshtunnel import SSHTunnel

group_name = "ht25_2_1dl301_group_35"
group_password = "pasSWd_35"


def program(mydb):
    mycursor = mydb.cursor()
    ## Get all department names and show user
    mycursor.execute("SELECT Dep_Name FROM DEPARTMENT ")
    for x in mycursor:
        print(x)

    ## Get user input department
    user_department = input("Select department to view products: ")

    ## Get list of leaf departments
    mycursor.execute("""
        SELECT Dep_Name
        FROM DEPARTMENT
        WHERE Parent_Dep IS NOT NULL
            AND Dep_Name NOT IN (
                SELECT Parent_Dep
                FROM DEPARTMENT
                WHERE Parent_Dep IS NOT NULL
            )
    """)
    leaf_departments = [row[0] for row in mycursor.fetchall()]

    ## Check if user department is leaf or not
    if user_department in leaf_departments:
        ### Leaf department -> list products
        print(f"Products in {user_department}:")
        mycursor.execute(
            """
            SELECT 
                Prod_ID, 
                Prod_Name, 
                ROUND(Prod_Price * (1+Tax_Percent/100) * (1-Discount_Percent/100), 2)
                AS Retail_Price
            FROM PRODUCT
            WHERE Dep_Name = '{}'
            """.format(user_department)
        )
        for x in mycursor:
            print(f"\t{x}")
    else:
        ### Not leaf -> list child departments
        print(f"Child departments in {user_department}:")
        mycursor.execute(
            """
            SELECT Dep_Name
            FROM DEPARTMENT
            WHERE Parent_Dep = '{}'
            """.format(user_department)
        )
        for x in mycursor:
            print(f"\t{x}")

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
