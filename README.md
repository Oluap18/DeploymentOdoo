Passos para a replicação do software odoo, através do uso de docker e haproxy, para máquinas virtuais do google cloud.
Executar os seguintes passos na máquina host, de maneira remota.
Requisitos:
- Ansible
É de salientar que o software odoo será corrido em containers, pelo qual necessitará de conhecimentos básicos de docker.

1º - Vagrant up, modificando a variável "num_vms", para o número de máquinas a serem criadas.

2º - Modificar o ficheiro /etc/ansible/hosts para a seguinte configuração:
[haproxy]
username@ip_ssh_máquina
[db]
username@ip_ssh_máquina
[odoo]
username@ip_ssh_máquina1
username@ip_ssh_máquina2
username@ip_ssh_máquina3

username: username utilizado para fazer ssh para a máquina virtual
ip_ssh_máquina: ip da máquina para o qual é possível realizar ssh (ip externo da máquina por default)
Nota: Uma máquina poderá pertencer a mais que um grupo. Poderá colocar quantas máquinas necessitar no grupo [Odoo], mas apenas uma máquina nos grupos [haproxy] e [db], visto que não foi feita replicação na camada de base de dados, e apenas é necessário uma máquina correr o sotware de balanceamento de carga HAProxy.

3º - Modificar o ficheiro ./odoo/entrypoint.sh, linha 7, ": ${HOST:=${DB_PORT_5432_TCP_ADDR:='ip'}}", onde deverá substituir ip, por o ip interno da máquina que irá suportar a base de dados, que será a mesma máquina do grupo [db].

4º - Modificar o ficheiro haproxy_scr.sh, linha 12 e 13, nomeadamente:
echo "Executing ansible-playbook haproxy-Aux.yml --limit username@ip  --extra-vars 'ip=$ip port=$port'"
ansible-playbook haproxy-Aux.yml --limit username@ip --extra-vars "ip=$ip port=$port"
onde deverá substituir username e ip, pelo username utilizado para realizar ssh com as máquinas virtuais do google cloud, e pelo ip da máquina (ip para o qual é possível realizar ssh), utilizada para correr o software HAProxy (máquina do grupo [haproxy]), em ambas as linhas.

5º - Criar um ficheiro que possua os ips internos e portas dos containers que irão correr o software odoo, podendo mais que um container correr na mesma máquina virtual, desde que a porta seja diferente. O ficheiro deverá ter a seguinte configuração:
ip_interno1 porta1
ip_interno1 porta2
ip_interno2 porta1
ip_interno3 porta3

6º - Executar o script em shell "deploy.sh", tomando como argumento:
- Nome do ficheiro criado no passo 4.
- Porta dos containers a ser criados, a correr o software odoo.
Nota: Ter atenção, ao executar o script, será criado um container em cada máquina do grupo [odoo], conectado às portas especificadas.
Ex: ./deploy.sh hosts.txt 8069 8071
Serão criados em cada máquina do grupo [odoo], 2 containers a correr o software odoo, um conectado á porta 8069 do host, e outro á porta 8071. Caso necessite de criar apenas um container numa máquina à escolha, deverá executar o seguinte comando na sua máquina host para a máquina escolhida:
ansible-playbook /path/to/folder/playbooks/odoo.yml --limit username@ip_ssh_máquina --extra-vars "port=nº_da_porta"
É de salientar que o endereço da máquina (username@ip_ssh_máquina), deverá estar no ficheiro /etc/ansible/hosts, não necessitando de pertencer a nenhum grupo.

Por fim, poderá aceder à aplicação Odoo, acedendo ao ip externo da máquina onde o HAProxy estará a correr, escutando na porta 8082.

Caso queira executar um playbook na própria máquina, basta executar o seguinte comando:
ansible-playbook -i "localhost," -c local playbook