include .env

install:
	add-apt-repository -y ppa:ethereum/ethereum \
	apt-get update \
	apt-get install ethereum \

account:
	echo $(ACCOUNT_PASSWORD) > ./kmuttchain-node/password.txt && \
	geth --datadir $(DATA_DIR) --password $(DATA_DIR)/password.txt account new \
	| grep "0x" > $(DATA_DIR)/_tmp && \
	cat $(DATA_DIR)/_tmp | cut -c30-71 >> .env && \
	rm -rf $(DATA_DIR)/_tmp

init:
	geth --datadir $(DATA_DIR) init $(DATA_DIR)/genesis.json

run:
	nohup geth --nousb \
	--datadir=$(DATA_DIR) \
	--syncmode 'full' \
	--port 30310 \
	--networkid 4649 \
	--miner.gasprice 0 \
	--miner.gastarget 470000000000 \
	--http \
	--http.addr 0.0.0.0 \
	--http.corsdomain '*' \
	--http.port 8545 \
	--http.vhosts '*' \
	--http.api admin,eth,miner,net,txpool,personal,web3 \
	--mine \
	--allow-insecure-unlock \
	--unlock "$(ACCOUNT)" \
	--password $(DATA_DIR)/password.txt & echo "Node 1 Start" && \
	grep "enode:" nohup.out | cut -c73-224 > $(DATA_DIR)/enode.txt