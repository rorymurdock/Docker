# Delete all ansible components
# Leave the base ansible/ansible image

# Number of nodes
nodes=1

echo "Deleting containers"
docker ps -a | grep ansible-node | awk '{print $1}' | xargs -I {} docker rm -f {} > /dev/null
docker ps -a | grep ansible-master | awk '{print $1}' | xargs -I {} docker rm -f {} > /dev/null

echo "Deleting Images"
docker images | grep ansible-master | awk '{print $3}' | xargs -I {} docker rmi {} > /dev/null
docker images | grep ansible-node | awk '{print $3}' | xargs -I {} docker rmi {} > /dev/null

echo "Deleting Network"
docker network ls | grep ansible-network | awk '{print $1}' | xargs -I {} docker network rm {} > /dev/null

echo "Creating Network"
docker network create --driver=bridge --subnet=172.16.10.0/24 ansible-network > /dev/null

echo "Creating master image"
docker build -t ansible-master ./Ansible-Master/ --build-arg nodes=$nodes > /dev/null

echo "Starting master container"
docker run --name ansible-master --network=ansible-network -d ansible-master > /dev/null

# Could improve this step by using a shared volume but this works fine
echo "Copying SSH key"
docker cp ansible-master:/root/.ssh/id_rsa.pub ./Ansible-Node/ > /dev/null

echo "Building Node image"
docker build -t ansible-node ./Ansible-Node/ > /dev/null

echo "Deleting SSH key"
rm -f ./Ansible-Node/id_rsa.pub > /dev/null

echo "Starting node containers"
for node in $(seq 1 $nodes)
do
    docker run --name ansible-node-$node --network=ansible-network -d ansible-node > /dev/null
done

echo "Testing Ansible nodes"
docker exec -it ansible-master ansible all -m ping