(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �*Y �[o�0�yx��P�21�BJр�$��	�����\Z6���N$$��Tm��D.����sll��"R�|7�C�عN�݁�v���b�
f�I�`E�D؁�VG�*Pl�b����R$#� P������5�J�H�}O�f�"D$�
� \䮨�${ ���`�q��FDx0W[���麽l���n������tt��(|��:�u�UKf�ZjC^���ȋ���2�Q4][���޲Gʴw3V݈�(�ѶuMϖ3�R{��b"o��ha-g�M�ۚ����$f�~�Ҿ�)˙�h��`�)�ޛ�@1��q\�A���Df�hjtc?ɂ $&H�	v��!�����p4.��Bw��|X��ѠK�W�}-Z����8����V�X���ҟk#��eM��"F���Nt�US����>pu�[��T�`o�i�\�e�0܀�j��P �>�e��m�!�t@�;��2��O>S��9M���/A=p�ݚ��g���5��2�������bK��Nf�N��W����>� �8<P�|�CVD�����ª�SP��y١�y������<U�(��'���p�	���q�g.:�h�0=�I�6��y��[�4+�t��$�,np��ٹ6fӭI`�|���	X/凰c�@E-Jhw�T/��-p��GNS,AXa/�('�I�3oϗ��g󦂛���B~�ɣ���>�N��W/�O�����p8���p8���p8���p8���Oc�4� (  