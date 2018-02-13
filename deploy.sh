i=2
myArray=( "$@" )
echo "ansible-playbook ./playbooks/postgres.yml --limit db"
ansible-playbook ./playbooks/postgres.yml --limit db
echo "ansible-playbook ./playbooks/haproxy.yml --limit haproxy"
ansible-playbook ./playbooks/haproxy.yml --limit haproxy
while [ $# -ge $i ] 
do
    echo "ansible-playbook ./playbooks/odoo.yml --limit odoo --extra-vars 'port=${myArray[$i-1]}' -f 10"
    ansible-playbook ./playbooks/odoo.yml --limit odoo --extra-vars "port=${myArray[$i-1]} -f 10"
    ((i++))
done
echo "./haproxy-scr.sh $1"
./haproxy_scr.sh $1