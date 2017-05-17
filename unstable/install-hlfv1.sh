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
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �*Y �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[�/�$!�:���Q����u|���`�_>H�&�W�&���;|Aq���Q�������Ӝ��dk;�վ�S{;�^.�Z�?�#�'��v��^N�z/��˟�	��xM��)����!�U�/o����;����G�"��	�P�wo{�{�h�\�Z��r�K���l��+�r��4MW�/��5��N�;�����q0Ew�~z-�=�h, (J҅�����<��8^���k��P|������E0��pʦ\�F�9��됄�{.�P������4E2�k;E�(����}�ث�s�!������?N���?^|��RC��?\�_��Y������.��km�:�AJ��&���ĻlR_�L~o�Q�k�VCٴ��MfBj��|����F_!X�b3h�q<u��ؤ������D�)�F=D!���t��S�N'[	��n C�T��>am�}yq �HqՏl���_�k߾A�Ɗ���c�������Eӥ��;���FU�����qu|{��у{�����b��O ��/�?/�,�|�6o5�,�M���A.s �5e)�ɬ�m�!ǳ�Rܶ���\�&�Y��i�q��e9�k�`jZC�[�� Jq#�D�S�&e�p�u#2�q�p�)��)� �6�8�C֐��#u�D]���Ev����A܉�q�jr@1�&��Z=7rw
G� �qEPr�x=X�b�#���4y���rK;
��[0Qx�Tv��й������i,"om졸�f`p�s�,�\Í���-�ܷ
�@��Y����_1��㡹7��R1���)n�M�'
�No

�8�WňP�<�9���n$�)a7�a/�-��bc���9}���)�h'�rVr�P����]i�Y&n��Vw�t3עf��)�8>�'�"�xy2�S4�E������5���'�K
P80y�(r�r�,��t�1)m�&Fv��Ê	��R=0�6H�\�h�D�i��&C!J !P�/k<y:9�����	t	#.b�fu0���n����ڹr�Iڒ�hj�x1��C&K f�ȱh�sfы��(�e��F��=3��/��l������(^�)� �?Jj����S����%��������'����G�y��S��]��H��9Zr;ˇr$��B?b�K����P�I9�S�bqU0U��"��~�Wf�}�"�;� Z�XX���+9$�MY���q��h1Qt+��)�)�a�P_�&N�&.�n��s����2�M���4���j�vZ�b�w� 4��[�.u��z��3w�V�J�Bx��К0
�-�G�H�-MSΌ�5 �$./�@���y����*�q���1�����8�t�܇�.��w|K3ymJ
�(�Hs?4���\rآQ��R�l�9��L�k|'p$�,���&��/�D�0����t��<�1>�@��亖L��)�fV}ȡ�a��?�����k���������?J����g�������K���2P����_���=����1���?Q�������?3����JA�S�����'}�p�/�l��:N�l��0M���H@�.���Ca��(����U�?ʐ�+�ߏ�(����2pA�����IA+G�	�2�x���
� 4.�7�|x1�g-[�m[����r�45~��Ko�R��d3D��/9��g�A�ۑ���s���W����v+�j� �n���iX����4�?3����/%���!*�_���j��Z����ޥ�?3����R�A����?��W��3����̡�H�>BaJo�vZ��?������|��,a��Y�c�gb>4����m����T8.Wy �Ȥ���L꽩4��s�m��{�;�9TD:FwE�z�ӹ��6֛ɼa�]c~��@�t��ʝ��1v���k̑��#�r68F$�{�����[�i��1K �L�0$�@ ��6PĖ �!/X��k�N8a7E�j�de:�� �n��;���GӞ=4�*���TQ��w{�χf=�/��$d�����f�u��LiYZw4�C^nvL5QBډI�H�,E�vC2�	\��d�Ѓ������%����?d��e�C����?]�)��������?�x��w�wv9��Z�)�D����������_�����+��������!���Z� U�_���=�&�p�Q��Ѐ�	�`h׷4�0�u=7pgX%a	�gQ�%Iʮ��~?�!������*��\��2aW�W���X�plNl����{���6[�A�z�^��C	��yܩ�JJ�E�Il/��j����hc7�1c���������<D i�l0h�C���<�甒S�ݬ��{7��8���Ï����Gi�Z�/o����w�����:��\(��ח)���t5�K�{�� ������r��8NT�/)����^,Őj�o)��0}����������F���g1"`1Ǳm�el��P��%X�=,�h��]�� g	&�f�G����P��/_�����O�������.���}�Z"&
/&�nPo��4L�˹z�t�H�����?�M��]��簺��\��@w��G��p��|�y�H>h��[>#~*�m��C��Z�D\TG��A�ك��W�?��G��������#���+������S��B���+�4�d_-T�L�!�W�?� ��V}�C)x-��}������?w�J���U�k,a	�0�������G��,	��3���s�=�J���.�j�u#}�F��;���@7�G�@CwA��h�A���vn�8P8��G`�t����t�v�#�|����mc�y[�ȵ�f��#<���39��&���k�͛#���L�-��%��f�f�����'�n��(F�|d���A7��:���6��9Z��5��nM]9�5��	+�����Bm���_�SI�;�!qk!̻��!@]�Hr��pY�n���a���&8L9��Ӽ��+.��Sh+��mg#���s�O	+g�O�� r��A 5Ý�i'�I�D��?�}z��Vu}�Ț�Ґ^<�G������������/���O���7�s��r+7�D������8�W�	x�������q`�~��[����NS!�����������䙡��7P���F���>���my�@M�wM��-���� �B$�vr��))�ci�J�hl�F�˶���[��SS�m�ߚ���&4�T6c��ij]�r�
��H��'}5i�v��@���q6��K����>@ k��#'P#�ڬ��]z�M��J̳F��K]��O�\;|�՞ق%w��Z�o�~�;�F�&����-T�}z�x�ϳ���#��K�A\n�#4U�������'��T�J�g��j����2�������V���Z�������j�����]��\l�cV}�s9�\��[w�?F�+�/�W�_��������O�쟭�T��V
.��#l��0�D)ơH�p�g0�D|g4�iGp%2`}*�}�\sëS`~+�!�W���B���O)�`�PZ�d��a�2�f�����9��6ض��"o䑶hQ����hN�m�`]	otw�K��#`����;VaDI�1�ַ����0�k�d=�(G��b(���:�b��W��/v�~Z��(�3�z->�?��h1۟��B�h��_�`�Y���������O�S�ϾB��k#�K�6����Z��?]�^XL��vҩ{��_wuCW�5r�\ًdb�>�/��4^F�r}��V��I��e��7ͮ"~�����֫c;����$N���:�E#$����_��b�F���Z�&�+����:jG�kWE��q�"�.�ګw~r����sEsY=pr^�ʩ�6X|=�M�jWީ��b�����T��o}���^����Oo�vT�
׾��*
��
�#�i��W��m���VWD]�o�*�sӑ���A��~�r}�y���ڗ��h4�·�l_+*ɝ��sG�w�:��4̮o��Yz���vy�Q�=Y��=�x�jiA֟� ʒ;���
�N����#�j/���X�I"}~����<<��>ΐ������yew�����ݮ�������*�~�����=�����E�����wjj���2����'k8�{=��ԅ��z�q������Hj�Z�a�MX�@��)��x>���b�?��|8"�۞�������n8��H1�]]��@V�� ވ#��!+bw`|c��㲪82��Ӎ�8�T�9#���j|�,���0O�lo�N7K�lI]g'��=������x���j����ƺN�q�\.����P�\p3\�=^��{�P��[���ۺ�Mɵ���m����&�_���M�F����'%�A�~Q>(��1���v[�v���s8\��䞮�?/}������=ϓLg̃�M�Wn�͠��LCĮ�~�H&�X$�g����h� k$���R���H<��ֶ�P=I]���}N'��u�fZL�2:]Z�����ټ�yxfs��s@	��0.�Î��;��$�=�n��Dsp�n�\�wBs�-3���U�n z-��6`��j���G���n+����6j��U� ����3���s�J�~��d&;�!���d��u��ĸ�R������n猛p��>��kƙ����҈y$DfUJ��g�e�hY�}�F����[(-�KCƬ��+|��]�=t��,/j���r4E>�h�C޷h�Ц�9
�.�dé�G�S��b�p�~Gp:91�Ӏٝ�#Z����� vr��"�A�;�ʢ޾sa�����1�I�Vc�2Ǻj��/dtI:�4`q���9�:�!���p�w��9��S�l�k��f$tQ������7��]������
C0��e�����C�|��.8.���_�a*�Jc�1CJ��&o=�^��]�E.��-j�"Ƀ[kgk��.לP�Օ��М���H���=����L��*�T����
��w�y>��܃sэ\�f����ǜ�n��!3�%8��t�v1A3�6'f�aoZ�w:��Υ�S����0W����ꪽ$���u�v!Gk��]{�#Xvu����W��j:��>��Ѽqѹ�B�{��'�daý���U���ܨ1�w��j��g�y�x%���֞��c?��y���F�n���=� �l{Q��G�ض��� ��l��U�>*`�
�����PN���!8ix����ۯ�q��p=vk5�������v��?z��P`�ҍ'(�gNp�8��	�~' �qq��;7~t\e>s��9�s3׿� Rc�36�O�7���7�9#Y����z7��yx/*r	:���z�Gg��1��<'̞��i~"�{X���;��l�Fa��ް���j3������c��[�6p��gH���"��vz�p�6�, �NY���/���Ur��a���y������>'���h�d����os��[�&�<��tw@?�Q�R��p����O�Y:8�.�cJt��'d�>��5�B(���J���*
.2!�ʞZ=��QB�Qʋr˩jK�	I�����	m���2Ų��z)5��I��^
Qx�K�����O�LX�	k3aWa�BO���!a�}6<�����֦���蚝�R3��=`����nUCLpl-��)و�[�]�d ����D`����2���ׯl�L��ITh�[��@kpGBI1&�w8��H�0�ᐕd�&���)�i�A��#ky�<��{�gd��
��D6ar��[E<��*�uвBP��Z�����/�d����ka(FIs�N��{�]��n&�uz;/rA�f�]���w�w_Y�Ǥ,K6`�Q�-wf3��Y.�};�J�`8�N3����=-���b��"�~%�c�TKlR�B�]l��P��2���6u8e���kE����B�
(��}Lϴ�Ԝ����]�,QՃ�|�>��IB��1�U`�@N�0�ՉD�'o�"���2V�9�NTA��-$�R�H͏�L9�+T�n_,!���B��{�,�E��_�,�������D�X�g(ߪpy�$�~	J hb�N
����m0/�W�<��C�a\�孝\;1���l�����0�h�	��%,&kRl���(� �0)W:S�dNY���.U&�	{�>��m�j�O%U��� K���Z�`	!��&�tчn0�fCRw|D��5U�MHy��P��H6)��2H�=�b���,N�g�}6�g[�g�8�?͉�k
j�ͫ���ڕ������X�b�t�������G�ȡ��>�g:3�g����<[9TUw��l����iC7B׀��^WS�D�g�7?�d������8��J���ɍ;�M�(��浶Z3�jh��TU����u��@�u�8�ɒl�8��fk2�!��^�?�r���m:��9�Y�
���',����A̳R�b���^��zS�Y�fɌOL�L��r��΃Ӹ��}1����ːX1#������8QV��g�� �6#���'���W�V�<r�(���:��:��������`嗂��G&���I(�L���D �
w�<[ٹ��c_x�RGB�-u4gG����`4(Y�y�S�.8Xڳ���� G]pp�*`z�͚2�pO���f"�'�MMpgHmJ�~���6�`V
tQ&���D�?$Zq$B"���$�A�[D�l1�<�ם�d�Nj\�W/����ك�A����h1A��Cx$(��c|�4&�CҸ9d�����p,Q�4L�u{��p������Z�d����4�����t�Jܯ�-e�{���\�z]���a��N��S��l��I!jAu��,`�0Iz�����q��{��kN�8l㰍� ?ֵ�%�ݦ;��L9��h�L��L+�@,���]�֩�C���>���r�a��ߺr������=,�e��H�'��� ��
���R��D�\�L��y�6�@*opdw��A��RT��<X=(��E&1pԠȤU`�n֔e��������l0�Q�JS�N\�Ai�$S8"�S��\�	�(��|��0��J��!�r{:�,w�������RJB�����!{c!����XQ�n�a��v9L���R�oG=;�A)ʓC��D��FP^�˗v���e��>*߯z�TO�r�PF\p�I T?�Ì>�Е-����q��51�%�p��M��r���t;�$��K�����+{X�q����f��~ܳ���2�����+��V
ɭf۸n5�v!��FYM���L[�p�jF��������M�RQyM�5��n ���y-��`}\(.	�~b��5p*��^�qWꕻ��F���q:]a�����z��߾��z�O#���z���~ח^���o����5�j����i6-��~�u��D�{���yl��eI���x��?��A������/@7�~ ~�߼�/>���ȟ�?	}/����āܺv���k�2���ۼ6�NT�@��7⟿�{拍�I7�����˿��o|�I�u
�FA��?MQ;_pBo�R;_���6�Ӧv�4�&`S;�������v@�H��N��iS;m�������C�-/#��!H���@��,a�f��	��k�m�����@=�x�1C'}�~���צ�	/B6��v�l���)���j�l㰍�=��#y��� 3X��kS�l�yZ��;�jϙ�����93�q��q��a����\��9�;w��ڪ��w�<z�d���Z�������d';�o�
|��  