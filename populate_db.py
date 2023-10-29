import mysql.connector
connection = mysql.connector.connect(host = 'localhost', port="3306", password = 'password', user = 'sail')

if connection.is_connected():
    print('connection established')
    cursor = connection.cursor()
    sqlformula = "INSERT INTO users (id, name, type, email, password) VALUES (%s, %s, %s, %s, %s)"
    cursor.execute("SHOW DATABASES")
    
    a = "$2y$10$mO3Z3BJd1T0WfeOfWXgvlu.5Ot6NiNHiZYNqgjFDNcSQ4sAFEwc52"
    
else:
    print('failed connection')
    