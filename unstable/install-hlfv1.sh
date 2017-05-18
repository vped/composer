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
� �vY �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[��;1HB�u��	7�'��ʍ��4��|
�4M�(M"�w���(Bc4F���1��R#?�9����vZ�}Y��v��\��(�G�O|?�������4^f2".�?E�X%�2��oS�_�C���_�,��w���叒$Qɿ\(����⊽u4\.��9�%���}��S���p��)�+���k��O'^���r�I�8
�"�;y?��{4%�b�w>�=�p'�4��?+�Z�?3�i�v1w��<��)��Q��Q�b��q�e����Q��HsmǣHE��o��{~�2������I���ǋϢ_jH�����#8�!�5�����eb�-Z�<Hi�<�DQ��x�M��`���`5Jq-�j(�����LH-;��Oc7x~��+�\l�M�B ��������y>���>EѨ�(Ds�Ձ���x����d+!u#�dh�J3�'�m�//d])n���-Q�r�u��7��XQ^z����S�����h�t�t�s���FU�����qu|{��у{���QǞ���)x��yQ7dI��y��e�o<�nr���)K�Of}o�9�5��E����p5�Ϻ=M��-�!^�S�b�2�P�t ���0)�����e�C��Ny�NQ����������3� �
`��(��0�ݏ�N4@�U���7��x�깑�S8b	��+��+���B3	�\��{�p��[��Q��܂���@��5�?W'Nc9xkcŝ4�s�kf�7�n$m,lq�0�U�����\�O�"��$ͽ������Nip�3m�P<Q(tzSP(@d���*F����͡]_�w#�L	��0{�nq��V�����Mm@;a���K�*nG(�JK�2qs��3���58O���=!98�ģȓ����/z^ .ԏ���4<�\XR����G��H��eQV���I9h�71��oVL�̖�Q��@���Fc$J�Ms�<0
Q� 	�"xY����Ɂ\&�$�H�Kqc6˨�9�v��oX���[NҖ�FSŋQW2Y1��@�E#�3�^<�F�.����lx6���Y~I�g�����G��K���Q�S�U�G���� �����_���Dw��5��0o�w�~�K�[�{�<�CKn�c�0C��q"T�G�z	�B?bԷ*�!)Gv�A,�
�
�]����̽OS$y�@�|� �Pt%�ĳ	#�y"X�]2�ؽ-&�n�8�5�5�!���ĉ�����]>tn��Y���^�湘[��N+\�����{�Х��Soz�.��Ti�\OT�Z�@a����h�i��iʙ������E�r>� ���S%3��r9!��Y��g���n���P��{��oi&�MI!%i㧃F�s��@[�!j]ꃙm3�i|����$�E�|����Ś����`�~�n3�'0 ������\ג�p5E�̪9�8L�!����S���w�7��{��$�*��|����y����Q���������?���������@q���2�K�������+U�O�����):�I#������8E�ŏ�4e�"����Q~�d�b4�z�W���](C���?���H������?|�'��&�<i�'�ˬ�YB�+<�8�0��(�������ll��m3b2n�I���-�/�eK֓�9�6��s�i��nG�sln���_n�ۭ �Q���R��a��^�������*��|��?<���������j��Z�{��������K���Q����T�_)x[�����{3��#�C��)���h��t��>����c����f�M���� ���&s�;P�\��#�.�CL2����ܚ�=���a�|�P��I��N���lXo&�w�A�1hJ�x\LХ7(w�j��1<tO��1G�������t���stNnq���,�2�s����g�@[���`%N��;���g�m��I��(/�A���{�?-L{�dЄ�NSD�>�1�?��h�������Np���Y�3�ei��@y��1�TpD	i'b$�#�����HȜ'pr�CZ�?�����g��������g��T�_
*����+��ϵެ�]��G�]��h���2p��_��q1�cD�V���������\����P�-��E
R����K��cl���u(�p�v};@�Y�s��q�%Pa�a� !}�Y���*���C�<��I������*vE~�Z������֘.�m��H�n�����'/H���?�@�N�ǝ:���А�Q����2�F�	�6v�3�J������nO@�C���V>����3�pN)9��ͪ��w����S�O?�����&���r��O|�)��X��������}}�R�\�8�T��W�o_��.�?�H%�2��i;����Q������a�;����I���O�����]��,F,�8�M��M��b��b������,����,��h�PTʐ���?8r<��Z��|\���Et�RKD�D�ń���6�F��w9W���i�~�~q�g5�	^�뺻�V��KQ=�#r�1v��2��-ptˇ`�Oe��4v��U뙈k���6H0{0��j��������v�w�]���w��P�xj�Q������||���}i�P�2Q��_��P�|�MP�e����1��㿟��9+9�Vᯱ�% ��7�g�?�g}��$������7����*-û���֍��{�� �7�ݰ����s��Mk?lڹe�@��S���)�b^<�]h�i���Mb�ڷ�M�	l#ע�iV��X�g�����z�N��7o�(6W3����V\4�ߛ��
�[g���|�G�-ãe�q�#=�$l��v�$�\h���@8ǻ5u�\�(R�&���t�*�)�sj�N%��ǆĭ�0����@ u�3"�mo�ey����A�Ě@�D0�ljN�����|sO���F���4�r�Yf<%���?m{�ȡ��<wJl���'�M�V������Z���"k�JC�y�`��_���'*����?�W��߄ϙ�?ȭ܀�e��U����O����K�������� ���5��͝dv�
9���D����P�'������7��6��u���>�=n�C�j
��k���m����=8"1��C�MIiK[TwDck6�^�͵F߲���m{���L�ص4�aH���dNS�28�PеDr��8�I�� ��B��<���]j�?6�Y�|�9���f-x6���nڷW�`�5��\��^J�r��{���,�C��z}��{���46a�Dw�h�"���������_:�r���*����?�,����S>c�W����!�w��ӕ�_���j��Z����ߨ��u
���?�a��?�����uw1�cT���2P��������[��P�������J���Ox�M���(�8�.C�F��O�L�8��C�O��#��b��`xu
�o�2�������_N��*���q����Lɖ�þeN�6;}�!Bs�m�me�E��#mѢ&/��1ќ��J;�����(���)�G�  �mow���c�o]�5�Oaz���z8#P�249�P�7�+u�Ŧ=4����^������Qg��>Z|�=~>��b�?=��@����J��O�B�����A��n���}�j5�F��Zm١��6�'~�𽰘����S�ʵ���"��k�����>}�_n�i�����\I�vU� ���n�]E��k�a�W�v���I����u��FH���׿Ni�������MjWn���uԎ�]׮����jE0]��W���<�������z>��ڕS;m��z���ծ�Sl��&���5|ɩn_�����\�ӥ��,���}sWT��nG���w����b���.����4DU�A�#�Q�����7�������k_�+���
ߎ�}��$w~0������<��0��}�kgQ�ٗ��AG��d�[����ͫ�Yނ(K��+0:���o��X<���^~�c�[&-����֋{����8C~Z�����ͷ�֦w������������3�X��W[ ����ߩ�y�Χ��ƛ�_kp���0N���R���ƹ.T���#��k���O4a���"D~��j��Ծ���}�߀����,n{����S�+��X�"��wu�oY廂x#�D~`����݁�=Z �˪����N7��dS)���ʪ�m����0<��5��S8�,�%u�=��O�����Ƹn���r{;=��N]���6���[�q>���'�I��d��z�N��;�R	!	X��Ђ�GH�� ������Zv�V~ �N�I&�Lf:�-��Jw�=>~��~��s�Po�i���%Xl:��&6�\�%��6�B�,�NщX���WÃ�tE�X:�Kdn���d��ֶ�3P�<I�����`_F�)2iwݱ��ӢĢ[��4У@��ׄ�c2/�bnrN(�����ՕEW]Uu ��e�ݮ��tM� C#Ԛxh�K�X�hv)� `-���5a�����G����j�M���cS�4g���̰ztI�#i���O�����/��-���[5�����+ĻE�3o��1�`毙gnN��zhN#��[T)�7���Ѷ�������)�PZ����UGM��N͸=t��l/j���z4���h�
C^�h����;�������g����p�}Ep:;1�Ӏ՝�#Z����� vv����#IW{�ڪ�~��������)�Nk��{Nj��/ltSi6�6aq������;�i���rû숂��]5_���PFV&:�t^3��?��ǣ5��fVa
���E[Y\}8-��B�i�}l�2��"�����L)��m�~�cr]�	EnZ��j���������ϒP��W[�В���^��#׎��B����͖tM�pc�Q��;��<8r�@#�O�*�=��X��֑��2�1pYB�N�8�e���ے�e���i]<�F��M�����R-vF�U{M6|e�*������.l}��>G�����]����Og�V��l�4��^_!8<��7h�����ժ���?^���g��n���|�y��E<J[v.m��O���]�{l����>V�=>O=���C<��ǃ�`��~^�C�߷��=pT 5�'1�'����hz��շw_z�����������_n=��D~���pX����np�4�|ݍ��a ����|�x�y��5�א�][����'�Â��}v��� ^ܕ��ts��7��<0!瑃�,�ؼ0`���oR�$^뜴x�I���� BaFV�����C���a!� �v�U�һt�&RU����85��^�,�Խ��J]�]��:(��@V��A4�,],��8�k���}�6sK�d�$�Q$os��[���"����0*0�Va�h|@Ȇ8̲y6<�.1�*l�'g«d�1����R$�͏�Z���)K:�T��F3_0R�U)�j���zGJHi�ȣᴁJ)c���*��ň��=��i��Y�0dU+Ǒ��/_r���a�nE�|"��GL�e�E��ܦ�a�M=�)�5?��f����Ss#dݫG��F<���1/��Nz��P.��w��~Uh&Uth$1P�Ź0^(Ҹ�vZ�5О��r.J�[�h1�� ��!+͍{\�V3(�A� ��r<��)t	Y�/�N�,!+ً������dCu���U�b�ˍr5���@���O6�$�r��j��P��B=�N���~*Y�Ԓ�q��		.v�6����D�IY�l���,{��n�?�%�ZI�Q�x��Z��c	+�^rB'-�{�x��:�Z�%ʙ��f¥$#{�Z'c
UmT�}�t�Br
[4�
c��L0,��"��(�%e9"� �VY⺏��C<Ӕ�l�ī��A����y_4�fe��e4�������{XXgұF+��jqP����DJ
u�"��VY��e�BY��+Kse�㉁�1�W�8M{�<�R�<���؛�zc�]�/~4�eE�C��ң�/�{�nj\���dK8��Q,���PS��)KTN7��(F�q=TUA��2�l�*pؒ�^�]�,\d���8���Ɛ�*����Q�����SR��Oy��n	p�nK�Tzh�u�K)ŀ����X>-��6Jy}�r���,n�gs|6�g��g۹D�?Í��Kz�+��.��֝���\�/lݱsy�������G��e�>�g�2�g�����"_;UU;� o�]A6C�j��܏����=m�y\�t���Q��0B@���� j]RQ&'wP��BV4�z���a [sU�K�3b����&"��%p�P�q�{���cyryl?�̷���<�o�mw�U��֛0��}������"�4jVˑ�"�B�{��1W��m���ļ��)�+��up��4��
����1+V��)��A�� �����@��U �]V$}������D��?���y��6�ۇ�9/�K��/ϝ8tOL���Қ�Z�(��P������KJ�𠭎����h.:�Ok��xX���6]p�rd����κ��U��4�5gс<8�,DJLE�>���ޘ�UZ�2��}|L#b���\(+��VpLu�X<���0��h�/��R��Q��*E���t�MB%�,��5��Y��؃�a�If�d1A��2���19}3�Y����p�D4�j(��A��{��\||@�=�NjL�\�@s�D�#�@V,�	Ez@-������*�G}X��|�i����x82�x/$�AB
wd}�f0���P�vK��B���j4��8.5�� ��c����c�q���z��G��A��s��e��:&�9f>ӆ90۳{y
>8��^䲝���yX�=,����x�x�{[<,'��Ɖ�m:���#|����j�ԅ4o~~D,)����9,Py����6��A�YL�5(2k�E�5gY���0�ryg�����"�v��#tX�c���݌!�O�ZG���zBɪ֧�V�`�����qt4�h��Q0&!E��`��X8m0�0B���E��}��b���q߁��p����'U�w1\Ԇ����E���rU�zcR�)�~%S#Ӣ.U�1��R3�ǃ(��������!��-x ��ӢQmV
�~��&=�f���]�yc�1�8�ތ�Tޏw1ⷑS�=�S��c���F!��l;7��V�.�w�8oȍ����=��ӭh��_`�oN|{�$k5]4р�v�w��k�_��BIER�-�mA���\����ܨWY���M���"r��vso���ˏ�����z?����/~��{��^��s~r��ou���k�ws�bZ9Q���8��������;��ے�{��կ�׷�b�/���7�a���O&x�3����d�k�w�_D�=	��_L� xp�N�~hqE/wEc2��QCv���K~���������Cy�?�}�ŗ�����y�7x�A~� ���v�̍��H���C�t���ӡ	84���|�}��u�N@ڡv:�N����l���z�v��oy��7NA�܄W)3���M�m�@޶�:�x��s���31t���!~�:��5���8n��3p>�:�R��c�q�f<�3p$���d��zin��:O˙3�D[�93δ gZ�3g�1�8nÜ�3��=���13��y��NZ۔���Gϑ�y^�R�����Nr�����m�+�$�4  