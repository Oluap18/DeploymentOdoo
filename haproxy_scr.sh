filename="$1"
while read line; do
	i=0
	 for word in $line; do
        if [ $i == 0 ]; then 
        	ip=$word
        else 
        	port=$word
        fi
        ((i++))
    done
   	echo "ansible-playbook playbooks/haproxy-Aux.yml --limit paulo@35.205.249.233 --extra-vars 'ip=$ip port=$port'"
   	ansible-playbook playbooks/haproxy-Aux.yml --limit paulo@35.205.249.233 --extra-vars "ip=$ip port=$port"
done < "$filename"
