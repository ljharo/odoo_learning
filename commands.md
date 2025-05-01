# para descargar odoo, la primera rama, ya que si descargamos el resto de ramas pesaria 8 gb, en cambio descargando la primera, solo pesa 150 mb

    - git clone --depth 1 https://github.com/odoo/odoo.git

## para poder usar psycopg2 y python-ldap

    - sudo apt update
    - sudo apt install -y libpq-dev python3-dev gcc
    - sudo apt install -y libsasl2-dev libldap2-dev libssl-dev python3-dev gcc

## comando para deplegar y crear la db (solo se debe usar para crear la base de datos porque si no, la recrea de nuevo y borrar los otros datos)

    - python3 odoo-bin --addons-path=addons -d odoo_db -r admin -w admin --db_host=localhost --db_port=5432 -i base

## comando para crear un modulo

    - python3 odoo-bin scaffold <model name> modules

## agregar mis modelos propios

    - python3 odoo-bin --addons-path=addons,modules -d odoo_db -r admin -w admin --db_host=localhost --db_port=5432
