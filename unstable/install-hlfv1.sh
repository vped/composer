ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

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

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.10.0
docker tag hyperledger/composer-playground:0.10.0 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

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

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� $�nY �=�r۸����sfy*{N���aj0Lj�LFI��匧��(Y�.�n����P$ѢH/�����W��>������V� %S[�/Jf����4���h4@�P��
)F�4l25yضWo��=��� � ���h�c�1p�?a�l4���1ᱱ(�>��+��#[ <q,���7�-���BZ�j�`�ۦ(Z}U��.E�󄵋~�鎬��:����L�'�QZghBK��6�"�� KTӰ۫���av�]��m���jz��)U*�*R�,U*fr�]����/ �&lɮ�]���:uh-U��.�;ZKnX�B�,�L��7X'���Ayx$n�ݧ�V,��M`���R��03[�A�~�}v6��uY�8�E�"��#	��^�`��*k��6�4\Ue��\�jB1�~7�fF��p-ӶLe7�ˇ��35�iڍ3C���J�0C�ґ�D��G]%���l3�Ƙ%��*���<g.���8���W䰁j�����/�s�Lw�j��4��Յ�S+����`��;�<��Gl�l�%挺)�jR����"��fO%bT,Uk)=;����0��dQ׿t��K���D<�/h�6�D����ǥ>��x#j�~+Ċ�o/��p����[����?��� <8%s�_��̿e�ito�
۝��A�_�y�Y����Fc�84�q����{|x�]��ꑆlw(�p-���4ɟ�ja��~L����J�VNI�W4xI��栉~E�4CF�=b�ߴ6��`��c����I埋m����/�ȿ)+]���ۆ� m����Eځ�,�T@4��?|t����Fk��e�Ţ}'Fa�LX�R�}P3�*$����:`�σ	ǀ�7���m��P3L��A��� ӵ�&�'��Ծ�`˅$Iv��aM9U<lMU�n����;0�y]8D���n�Nj��U:2�5z�I�bh.�����PG�VE;�Ȯ��������5C��t�>��ۮf�P��&��(�������g�^���FÉ�h;ORC�K��b��؋�e���sS9�2�D�xc������R����ii�u�&�����?���X�A�Z���_�?��Vh�:q��#;��jQ��}�!�\]W���G���|��HQ����M�B��A�ח���5y�"�=@���k\��T:�P{�n5;����� �6����]v^�NR3�RQ��d�r�u���˸���i��R!�p�Wx3�4��F���@�� �*�#桐1;�&���ar��`S ث ��a�iO�}Ƙ���s$2�Vu�#)�7���keALq��kC2 ���ѹ9蓘�L.��Xas�{��(���UR��4�ϡ�A��P���}�Aن��T0�JĲ?��~�{/s��lH��A�s7F�����:Pu<m~�~A�׈�n�9�;��xI��5 ��ׯ��Z#zC�z� !����ӡ-+T���f��Ra�����|?V�� 3�߬�뀍��ˆ9�=����gy.>-����������ų�<�q� KO�6��9fMak7k��Hs-׀��~kH�s�;������UR��au�oH7A�C�ͷ����`��� ��6&�ˡKd�f�d9�:�K�J�T|uqum6�F�Pm��6t~DF���p^¿��K`����CA͆7׉j�[���Y�X�S���R�ճj� �j՛��@�G;+�6D�մ_�ta��+x}�v������	%>�zN���߁w�����<� ����$ĸ���]PD��t�׀~��{M�R��xLttz@'�aEL���*�w�E�i�@(�$�_�"6G�+h����NΏ���j���Ǳ���[l�/���d�y��"���̴���_<��S��j�=��Pu4!�B!ӂ-���qT�@e�h�{����������q��M��`����݃����	�f������Â�\���pQA���S�%�7t��l@�2��i�����d�i�)�������@��J�uȗ=R��WI��9��v`�!DWs�<#��g,D&3��F�1js�2� L�	2EFM�6ЍP4(�(k�%S/T���0�}�����\�W�Sh��!��<�5F�U�� �_,���r�'n���//�w^(�̬�G7�k��U��#ǈ�C׏6pdOb5� �	p��h/�`�g��K���Q�C�;��b�l���M-]�vL�ڻo����^���S���7�_�G��GP�K5�э+`X^�˒�.H�^s�6��3�0����F��Ϟ��$`:�9o�C���%,/�w�,�(�#:c�,�������{���sE�y�����T��l2W$�Rd���J���_��Cs�r'p���N��������K84C���a;��F�!����[=���-����2�?�
�խw���P�1<�U��z'Ƣ��p����.f�(���(4�� ���2��ud4 ���n�9�#d�[���/(^�a�ϴ��l�?��	���8���u������/��s����x��^!��5QW�ޥax��&
̹�-H��T��멳�x&������K�=|� �o2���5�<�r��v �%�2���.�%r{�!�*���CI*���tY�T�Z����R�J����'��R�X�su�i�H_�"���r�џ`�|)���gy�.���R���i8��C#2�|x�;���b��3�'e.vu5�|e�����sՓ�I��\��Qo���l�KSX�e��W���J��5U���zw<��6f@�B
ض5M ��U�n4�w.�r����3o�v�%~j�}@X��wװ���>6�������Z�����������N׼�.\��%��9��� l��fv�n5S�6Y���6�K�i|���b�o�X,z�b���|�w�y������Z2�����{翉�o�?����\
���ð���G����ߵ��������!?<t|E�좰�W�[�@Gԉ^ƫ��gK���ly�|_~C��� �����+�p{����9q������p���F��_�b���|�_|���qs�`^���P�����W*�_��Z+��t���2w��e��>�B,��Y�/'l���g��_l�[�zj��Ƙm8�<ji�p�K�0ZV��s(x��sx�?�����f�_�W����e�<�\2x�0���ڀ<� �� =|�!����s4F@�X�����J��@/�Y?<3�-��ރ)��8�����_s�_]�~ee:�L���a��@���#*So��}6enŸȜ7R�B)o��z�Њ�O����M����[<t�D߄[��`���������6�n���V��k%橧�s���E��?m�	Bts��Z�����3��7_��o��?����������/0�`��;-�UX>!�-^�I$b�F�㹸y�1>�HDyE�B"�6�;��������߯�銷�[�F�I4MME�2D��n������m=��9E��6,Gu{[���/��h�N��߿ں�����W��R o��[���o�a���/_��?[����[OQ�?�p^�&y~�~���g�fX]����R���(����;���9�e�X�������F��>�{���?⭆�Di�m�qTf�#-���A���?h�u���`�
D��L�һi[mco\�l|�!BaY^���-F��D���N����$x.
���iʌ��B�ٝ��h�qYN�<�Ԅ:��#�@�j[x��	aHJ�\��r5�ɥĪDR��\.�=O�D%����ΕŢ[���W�f$�o�!u��A�}�;0Ns�猄pʥ�G5�ݬ�֤d����ҥXN��uTU5�-vY�׈�q�c�"s.ּ<����<5�}�+��{�i�'��E�*��0���MO/%��m��x��O+�y�c.�Ӣ���W��󽹘���R,T�A�<��9�T�q�8휤1�����y�Q8����t��(+��k�R���.�,q[>>�+=�<�Jǅ���B�^�2nN:�����y�Rj�����#"�P4��8J�B����F5y�F2Y�&��f+>!��l*��H�"��Yw��"y�f��j�n����[����\pbi4���侞���Z��:�ă�ܬ��P���O�Az�X���B�;�a�=88�V���ȣ�@�6�)�9�o����r!)�v$�\)���u�1��Y��O撉��U�w�_����\*YL*+��aq�[�q���D�-�Z*w��탣�{=%�mTO �#_&��D������s��ǵA=�O5#�\�"Č^�Ͱidɔ�ܠ�������za�Pf�a�O���b�,��	�K��1����p䗼����Xq��O������5���1�' �H�L�H�[��܆�(�7
w\�﫻C�E�O���i�������,+l��v�a9WG�8�NH�S����5Y�m�Nf���m���6���|��P#	�ۈ=�NKb���oa1{�i}-���e��H��2�R�X��)��V,��Z�2#��.�|/����������,���Z}�˪�T�X��[-q��1����|z���L:F!���|��ԣ������뿰Y���l�w���x�y��ܜ��ߜ�]��Z2�K��Lw N�}�GJ<�B�⑒>j��XR&]���7����Y��mʇ��S�(eN3���|�֭gʉ�a�F�d��KGwz�x8`�:�`��ޮ�����.�Ӕ}�Q����h:,i���P^��������h|��xR�9�H�d.Y@���05�q�ʐ�E3L=ñ��鷡���r���Th��C�a�!�����.yH%�m� Ұ��*��2Z8�K��K␶AO��6��ƏZ"g��&)@>=��������(�=�h��ѓU}�H�C��k�+&T�,V ��EЀ�1 !HX�hЁ ���#QCH�H����dp|�yxF�wi._[��,<�����>*��9w:<������8���:����%a���ws�h�A"d!���Y��p-�>o�v-�Wa 
��k����g�jb\9�z����	I�//��L��{��������n��q��=�è��n������n۫'�+�"X-,��	'B� $HHhW ��V�#\����?��x>�̛�8�<��_���W�?��WU6��h�>�&���,�sG.�l�c�H0��*%�zYM1!o��U��mj�J�Բ�
]v����#��u�|����R�c�G?p���	F�{�/�� �,��1r���
6@�����r��.4�%h��g���x3���zV��c�{���N�h��$v�g��=�����������d��M,���|(�Ч����1ĕAm�Y�T�p�*��99Q�1h3E_���X����LӆN��r�\��u��qHM!�D�z�k�Eᣓe2Wc��9 A��U������O�Ͼ��ΰW����TchLה�5 �� �&�Qc䲾p�|8��%�a�_m�8@�o�{N�2<Yc:��RްkS��+�D�tn
D5Ğ�|�3=��� ���7��deN>�G�<qٹ��U�z��L�5�v-�?R��^?9XS��5۷�xK�c�`Х�é5E�F��OM�E�Vx��VHɰ�.?פ;7��ҁ�N�vZ�����ᲡE�LE e�E�ښ�W�k�f"��4r�5G:�v����h7�!��V*�[_���9�ʣnz�R����ԩi��+qm�"�J�n=3�S荁,c;Ecl�F��t�$���_UAmH�u'b]=���Hbc���R_���J>��.9=�ۧ�J��_���_����tN�?�����Ol���O��B?��ߦ�ߤ��;�����[;���o���L
M��x����QI��Ⲓ�%#�x\�Œ�L$��b2��3 $%�v"��I�!���������Ї?���{�U�����>{�3c��~�?~0}磯��oE��GB�	����+d���B��`�6�����{�����> ���~� �/B��`�����j�1F �XƔ���E��O����^���yִ�>bT��?8�Tk5�>c�`E�a�᫈ ��#0]'s_�mVq]�1�\�QnJl'������tT8kυ�ZB8� ��p�j~!�yvIZ[��cQ�6�4���1�n�ǝaf!��Po�9?+p6%�&����ؗ��q7Z�	����1�7g`�����8�nQ��oN�ь%�m;�b����v#���k�Ġ�J�aӃ���/��f(����R��:	���c�ZZ�>�dǺ�+��k�za �e.W�5�s{����$$L�A�'�"6��Y�T�Z!�а���P��4V���v�`r�m�6&�M#�ْc�Y-��jM�K?O��Z�Z�T������v߈'g5��X�ڣA�?>�o��:dY�y5������Ŵ�
1Ϥ��r_+5��}uϚr�m/�JS5��O�n3��V�i���(M��RR�̭��+"G�zB��l�W���e�w�զ��/���/���/��b/��B/��"/��/���.���.���.���.�m��+�y�x�Q������D���k��"���nv"R�s����r'�׳��E��?q;�8Zr~�$�﹋�!P�Ph����������,�@���w"R�v����I���&��H=�*Ncs&Z��P嘥�:-��=[�odZ��@��N��vND���� ީۺ���L��1��KԒ׻��?/�~R���g�L<�L�+ϖ'����@�-m���������K�O�.��
EL�\&�P�xBM��i�vn�n�m��Y�4�dy����g�^.�
��k�f�Y�t��鱠7����Y:9�в]wo�^d��ۡ_�y=�(�z����k�o��\n�����a�����f��c_��F�,����a�е�"�i蝝o�v<����.]�}ev9]�`�[~�B�X�7Co�^�+pY�Џ����o<
���D�=W����Gn��B�� ��s��gך���2�|>o�g�Ԙ*�Z��T�$)��|>_��ϱt������w�cXX�N �ǖ��M�,@��Y.�6Qs�r��ٜ�.�ڴ�'��,p�`�B��%�"�v]g�3+�!0�� ���f5
5fI�
�i2�,�㪒;��d5ޚə!U�#��.�k�H����I:;���9��ּ��t��<抪Ə�������8V&�}<vˠ�Y$v�ͨm}�Y���Fƴ�x,ȬZӘ,$n9�:�jt�����R����l;�0�-�o����(�r�f��h�DY�'y����𘊈�I*>8��B�$�p��v��A�*H}1kl�
���ҏ��~g6*���b<����,�TpU<��k�*Mʒ(���0�7�5aZ*q�R�T������t������� 9���� ����$|�b�'�����(�q�2;X�u��N���g\�Sw���;�c�3��V����ҧ���\8�B.���l�Z+W�f*Ы�j��7�i����F��R.��-��+�en��	�^R��]v2�\���*=JkٳA�S����y�,p���m;�2��Y���#GYΘl��Zm�B�Pk�8��
�����V���鄮JD��9�f�EႫn@��ߧ0=Ꞥ�J�s���ؔ�\���	&���!8�\a^��PaTV���|o�-h<��{��¶�F�O�*����..k�^(&��ku�,"G�X9�<�ƣ-5�S�� &\�Jl�}��İ��H�9/~ԉ�.�y;�K0�3!Vq�����L�(��
��^�P�Q��<�e��fRoT9��8�[C.3����˚t�M�:��F��8��Ng�r8�X%��ԛM㸟����t��e�<�m
�y�-%�,����>S;-m�Pusd���,\�%�ϔ��N��q������KZ#�Pj���I�)���[tG�ON2�*=q=�P(��g����n�ۑ)J��$�Vm�pa6�/�N���4*�^�R&?,��B�ǡ�`��K��݂����晢~�y�<~���n_t�0
�z�x#jzt��L<pcպbZ�yq��	~���ૌ̩).�J���[ě��>��󸌆�TBCo����ԇ_~I�m�[I���AAO8�6��x��p�	��3�=�29�&;V\�ϗ�'��`���J���C��������E̛p34�[���f���=��'�w;���b��J�v�]�S�m:>��ҹ�K��z����ן[n��ቬ�͠��s���H2v���x4����W��/rE��.��n�t=%Y��S�kH7�;�0$�T��2ه��=<L2]t��Y��	*>T�9���� x���}�����<$؄5�5�y�5���47}��>���!����uP�A%�.]�Kb9~�Z��^��g����"�kJ�Ku��>Kǿn���r}��P[Dxzk����נn8����z�c\"A@���=t�=!� �anp�O���!z&1��T�>����=\ 2�3�m`D�p����e�&&q7��$o�fߘ�29R��B�B�.����_�:򒦖g0���
���U,a@�}p�lQ��Iw���j� W��p��x�m�C�X���*���cp�"B?�~U.��g��B75`�H��X�z��Y@� ���&��&纐1��n���M�����3sX�k��_��`B���+�W�N�!�r�ݓ�VF �Չ6�jc��urtn�$V��R�/�ٗ[w$~�@\#���)�M���E�޼yC�c�Q�oLж��q��Z/��v=l*>��~�@u~�	o ����zV�m�����\��Bt��T��F]k�\D늗2���Hx��ŷ�H9�����A�VD. �7N�@HJt&��y.+��jе��ř��"|l6p5�����N6c���[ZwK�D�1�upݏ�q"%ߐ���un2�V�WA�DW��o�F{��tg3�� ��Т����@o ة[�S"q������p/�u{�����V������i�%�gx�m�B)���Op�同����*	��F������V�(��a��C w��9��Q����A��̵�t�� �v�L��)?�=6n`�r�@ȑ`i��<���,,(dGV^��r%D�N�7lo4���+�Y򪊫��L�[,�-8�&&X�*���Ɩ���/�~$�%Ào������t̸Wj�#,�-#��@�J��d��N��<�Ʈ����+�#�'�����1@�VX�L<�1)9� ��
(�{��`T���!�C�|�����뱉Wֆ���)t��u��d�+Kܜ�F^�ѩ��є�	��!�����.�`�M����F�e��k7�#�n7�@���W ��ո����dی�:;��v��Z�y����w�\[�5���hju�[<�������W�A=��������u��-wn8�_�vx���u`Ƴ�h���:�=�ҧ�j�ga�ꆷ�s喌�~��ѷ2Yl�-��U�Ы�_�A�i�:����ك�rMAG\���Ѩz�DR� %R��1%��%��nW�Qr�G�b��LT�zR/��xZ�$85�%C~/��}]��ܳ����|`X�'�v�O7�ㄼ�S�r���/�q+�t�/0��@Y�K*�dH���#)�TT�w#  H&�%I'�JH2�CĠ$�%�R(�
�Tr. :��6�T�Kc���A��'�]>�ik�.po1;u6�mŐp��`k�-�ר���/��J���pX�2W�K��J��s�g�"M�����ȕi��s�Ƴ��"�R�|C��B�}���!ݮ_���%[֮hT�.	�*�>,�]G�P��9�V���
b�<>����h}&l���j����9�U��O%<�.vֺ�zGTl�t4itf�[F�3�/�SO\kd/�p�]�2� .��)!X��%���������;@/��J�C�<ϗ�U��o�t�<[��r�®(�`9��_'=N�2[��e��t����0�j��Ix2��Ձ�8'*��+�����]"N���Y7��=�Y�����s|��̉�J�H��{���ip��z�k��I^$���*-.*���-�N��<��i�s���H3t�{�E������J3[`�M��ޕ5��5�w���N݃��V}U�&@�B�A/�4!�I���3;v���z8�C�	��ګ{w�~����4L��D��>�_�[�줗W����]�&�3��i��g��~�.#Ǯs�~�T�����{���+��kz�|�f���?[�7~����>�\���ۣx/��߯g�w�m_��񖸰���q�~|������;K~��ޅw�HS�u;��g<�w�K�E|I�{�g�>||������\��W��I�����	�_P��������W��7��$M2��(������߲��Ӱ�(���7G��������g�4��26� (�������H�����������?������}>-P��O�)�fn��ߑ �g�~�g~��Lя�/��ݙ��	P�8��s8�I�	bD�����(1\G~(	"ƼH�#&d8�	V�2�)���ӏ�;?7p�����0�	����d����|TL��d����]mC�z�Ѧ\3��2��Ŵ�i�>����4�3����u� ]#�6�sK���f6��sl7��;�RÑߡ2�?�Lml��p�Mz��x^S{)���?Y��uy��x�矵;<p��!�_>��
C�����@��o�����Q ���;��P��
�����������M���(��/e�E_�O������n�?��� ��v�^
� K�������?���?��x���G�P%����g��,���?�?H s:aN'����K8�,�u���?� �����?��Â�����D����?� ��s�m�'EA��/���%��_�?�z���[��u�s��͕���S!�������?���O�=�����f������I���3ϫcY5B?����퓘�4�M��Ғqjԏ�"jn��f9�=.˻��:mP�������8�+�����J���*k�P�|W;.~#7�_��|j�$~���g��I���]W����չ|�b��mV��p9����}��q;-��i�}=13� �s�T�4]~[J֬�F�6<5��D5��y�r���;n֑�KQޯ��:d�m�X�]��G��K��ߖ4�B���a�@�]D!P ����������Kj`����`�7���?���?���4�?�@���������[�a��������� V��M� p�����8�X��=������{���|��#�n4���ͻ��_|�_I���C\���^�w4����K���v�]%}�#���QG���&��Mga8�s�K6�:oxk)_�R�6�HrJ=I�������m�m�&C����e��5�'���cٔ�k\�?���,獇�~��vn����s���;�_ر���`'t�DF��i}���X[���xf��b1�U�d�t���>��2�(=�b�'�JFN,�Ȑԣ�I���[XC�?P������(�(������4[mc� ���[����̳{�����H��G���GE!�S'r+r$'IAL�l B�a����!�!Ʉ|�1�1	3~8��=�����w�����ט&ʪ]��-�HW��ߞ��z!K%f�צs�I�����o�b�,�lg����y��p��zG��*17��lph��p�/���[AK�D�h��l��c���u9�j�[v�������a����P�����ԷP��C�W����)�����s���8�?���w�;�ֻ��^�/���8���xy-������!���j���M�o�=5i�'�oS�.��z�gN�11ʝI���%g	�IR�گ4�甎�\��v���_�|������d�-w�����c��!�[0��C��p�7^�?8�A�Wq��/����/�����b�?�� �On��Y��C����w:뿄����Nج��~�[��A��~���G�B��Or���_YvR⬶��@\_|� �[={w�Y����<��w�*q�� �ޏVl�m��R3[1��jI�ș��R��4�Ѭ,���u��)�K���5��@֣��Yu?ж�!���z��S�ʖ�i�9�x�}�O������}�� ۭ(���ね���,>	y���-ڗk�$i�Vu�S�@�Nٶ+���hZ��J-�m���<t ���TJje�̽���_jZ%���n'���۪��dc�[W�b���B�46j�d2iFsI���f�c��Ք'�4�ʱ�ju�*���l�2kl?ۘ}1O�E���Y��،d�p�{G����P����Ї
|�b�_:�#o�?8������i�����#�O?l������H��Q ���������X�'
���GI~�s~$+�B�G�!�K���<+�)�b��At��34�R�
1��~����;��� �?H�;��V������c�K�$�{=Y=hVΎ�M�=�ɮl.~��u:Z0X'z��8'vj��F�#w���/�b�`��z�ȷ�I�c���{<)��\�����Lץ�f�J�W�n[$��@��k���O�w��@�	>��/EK���b�ߐ��i��(���7���C4��G�	x���������o������_���_8����W��i�(�����7T��[�ֲg��QY�Wa��gs���;<R����S��N[c�=�ߗ׈��~_�����~�y��w2����O��x����Ŧ����5{��^��a�?�2^�N��Ԗ�Y�'�;�h�7�Fŏ�Ʉ3O�ֹ&Z�`�f�����Iޘv�JӔ�*q9����/k[K�W�s+�����P$b�i���b�^8qh��֖T+�9��\����mUv"����ʦ�'T=��å�I��Ry��J�fp���yOګQ91�k�U?F��J_������s�AϬ�}rrTYI�G�ۑ�.�F��Y���߂�F��|w\����8��y���� ��(�8��w�y��� 꿡�꿡���A�}����)� ����[����p�_����G��,��;��4�?
��/����/��{�����������/-�{����%�g �G��&�����GT��������_<����P0��9D� ��/���;���� �s���_8�sw�@����`����W��@� ����K8�,�u����D�@�AgH����s�?,����� �G���B
 ��=��� ��������A�����@@��������/�s��"����������?���?�������t�@�Q���s�?,�������a�;`��P��8��P�_����������,�uG�Q��P �7��i���� ��?��Á��g��@�����b0 c�Fd(�)�D)�l �K31Cq��dx�ЧD��J�}�gYN�7��;�����������1z����)�������T�����vB�F�l*�դ,MfOx-�G:� ����|?�hqx�4�%�wdK���v���ku֦;;U|U(�z�B��JA�lo��w�*�s{5�:I�q�V�n��i?�˚�;6�Z���b�W��5���RE_p̀����š��?�éo��a����8`��P�S0������}1>!p��������!cr�R���Ҳ�&�Rs��i;:u��Y�ڇ�(�����u�Y�윹u*��R��n�F4��4{4���[�F�C�ؔ��N	���i<\��1�v����8'����6�i{�s������w��"���n��k�' ��/��*���_���_���Wl�4`�B���{�����_���W������Ǩ}u�/���N���ا�\�U�߭���E�i��xUj���@�5̺�ng�nX.i����Y�6\	Y�X"҂Mb��(�8�=Um&}��l�v�Ɣ�ʧS&mFLjY�I3����������UN�j�~�x�/ץS/���[QrS9�[%�+��_'Oe�x�Y�E�r��$�ت�{���)��c�HQ$�A�qZ�ź���Y �M�V��p܍���#M�A�L�����G,̓7rv;�Tmμ�<Q�� b����W%�yV�$�^%�ڀ+Ż3+��kN����{{����mo�o�?��4)P<�R���	>b���~����S��h�C�G�w�?��	>���:�A��@�����,I���(���$u{���� ���O������!<�������
������*Gǯ���_���`"�LJR���g̛�<�~��GE��'��~~X�ʫ7�����J��[�~�����#�:��)�G|��ٹ�<�����ԥo*�S�sI]^2���[ے~W�*I��i5��YWSQ�KA�S_2��꺔�s��m�1�/ti�W��ZWSyԧŽg;FB�RwM�sYr�V�S�&e�s�]��Uf~w�	!���%惮�z8����k��>���˚+�P��,kr�)�G\��=�d�ʦz�'"-�'��ns��0%��,O�S�t��I}_��\iӇP�3�5k�gY�Īɚ���7'��P	[��ణ��ח��<H���_��bj�#Q&n�Wr�0$w�"�M�?d������Ώ]������-����=�������/"��B��O1~ �D��}iĄ�~��CiD�4I�Q(��4�!�C.$�@����:�?
8�����g��H�;��5>�5/��I0HB�����7�t���QD�=%~����+ߪ�-r�V����������}��w��C��ぃ���V�A�	<����(����[�ǁ�C�����%������ouӉ�V�GK:>�7�?��6��ǂ:=箹�K��x[�o��܏xO���#^�������k=����~���~63ɜ����JM����ޕ6+�m���
�^ŋ���� �vtu  8�CGG �
"������̛�U����t����"e����{�V�u�g��>R�{���\�\��u1Y�7ʎ��N��i�w5C})������<sE�rd_���~ȷ��]���;�~�&�]�cQ�aǦT�'e��Ti�ce�x����֞��|}f���q?֙�uo&i�����Fƌ!׳n�X����]�ci&gmkݍ������6�6�1ʋ�ך�+�Du����If���?�wE�q/��3A�?��:�t��c�J錟N'�(�0LM�T\��U,٣'�`Y�)B%p*قWk�{Cd�����ʳ�迷�����K��)�q썐cM��f�H� ��]]`�G�������˖T� �*[`��k���j������_(��K�ޭ��@�e�,�5���	��������C������� +�����&�gp��3������A���c���<v��}�%T[���ۃ[����?�ۜ|�h}��xf'�u�nǾ�( &�8rV	�v}~ꬄS��>u6�d�|�V��-����u�
�֩����t劝�\^[�km�������B^�<���y��Bg*����nz�1��Ѿ3Y���74:-���:��oL��N"ܠeD�x�.j8E����c��ï��������i�/�m��e�G��#�fٸy��Yq|?���5u�mjk�{�l����ژ�23�wM��ۺ��x'O,^R�7V]�䄃�l�mu��g՞!-&�Ҙ�G�/(C� \ŔcW�-�B�8�X���#�*5$s�7Y`XS�Nq$k6�V0#F|��V��l��Q���[��2A���B�_T@�������?�,�A��B������ߙ �?!��?!���A��U��\C ���������0��2�0�+
����%�a�?����������;迷��/��}���C�����I��lP�gn����3#d��7i��#���������_��y�:.���������������2B������?w�'����g���?�B䄬����?$[ �#���?������3��� O�E!��������ʍ��d�"�?T��B��7�	���C& �� �����Y�?����?��+���n(��/DN(D�����?��g� �� ��|����?��O&�S�����9���������e�b�?���B����� ���!��qQ���0����k�F����??@������_�o�X�!#��u��qӪ̒R�I0�R3k�Aꦺ4+U�0����$���VS�=i`5���M����ã�_�o��������@�$aQ�)̯��`-�msm�;��a��%K<��:���j:6��[4}v�ܯ`u�4��H vh���M���u���ĊX���6���=��!��2��2�WCta��.�O�H�7�
�Pz�*�pCi�i�g�BD�'-����w>kUy�$7�������1޻����`(B����!��?���oP����P������'�_>�)	�n��E����=�?N�ڄ�=b��8��f9��F0�;���wyf���5^㿦0Yw���h�jz�`;�u��ȥpt�$�N�JU<��L�Q��]�/���)����J�z�XK����P=�<�_�b����	y�����?b���P��/���P��_P��_0��/��Ѐ9����o�_����������_�cE���V��#	ܐ�~8�'ο���x�uN��kk�3�->lC^�����r��`ڧ0���io7�۩�M�]͛��*G��O�;&��%r.o�Z"ɶ���51u@��u�WԾ��W��1�QBs�չ]�%/���~�"����g-7���
8K��^.S���7���>k�ѥ�@�� �7���:�Wj�גy���D�#�8{>w�]��x_�����*խ�qt����[Gny�W#�Gd�z*�a��}1}gخ�I�;!5i�鸫K��mUv���5�kA���?具��_�d��"���K��M�G�I�?!���Q�g��1��Y 3�y���������7�؍��
�?���iX��� ��ϝ��;�?0��	r��W������������������H�.��#+��s��	����������qQ������	r��d������_!�����X�1"��o�1���_��8�����9�����z������^��M��:ʶ�C���K�GL=�~��ȷ����k?�C�J�GZ��|E��͍����k��ux����~ŉ��>w����yZ)���!��H���CsYs�N��dm�(;.�[8M[�Y��=��8:.H6�����ˑ}e���"�Z�{-�E�����pv�E-��R���&R�펕��>�[{�����m"��~Ygf�ֽ���#{�3�\Ϻ<��0JC����:�L��ֺ�uGm�3lrc��5�W
��r{3D������0(�����ܐ��{�x�m�����_!���sC����%�d�B��w��0������_���_���$�������E��n�������
����
��w����F!����_����4�������n�;bG�'U'J��g�j�_����K�ux�s���Fw'�k���  /|��X;���5U�nV庪�4�U����۲:��Jc*C#D9:l�x���ÁݮLl���c�B��?�W5kM�߯@�"��R��E T0��x��ִ�)�5�g�����ji�)�r�LB�l�a��uXM��2G�5�#�J#2p�b��[�����tY3gx�k��Ç�ߌB�?���/���	r�ϻ%�?��+�W�;����,P�'k$���4iUWkU�XV0�0)L�I�� �j͠p��T3MJ74�6jU�X����~�?2���������l�=��1f�^Uk�>sF&v�_M�p�ts-�V���y*��3m�����V�?���Zo6���������v��B��Q^��=%r��p^N�"�	��t �zت�`�ϯE��������"Py7����?�����?�!w�Y0	�n��D����=�?��L함�$�C�RGפ:]qo�iEb���Q���������?Q��hG��_'���GnP>�[�)���i(L�V�0Z���S�;�+��W��+i:�1� �m��r�MhΎI@���(F���E�����G������9��_P����꿠��`��_��?��A�EU@��/�i��,���kٺOO�C�D�2��F��ݤt����K����V�\x]P^[�^�t�S�~�w���q��6{U�׶hLj<�O5d�V�բ�D'�΂��V�J�66ϔ�j�~�h��(wv]n����S���:�Sٸ��y����x�q�q���1�Pb�c������Ƚ����Qk���UɋƚRd^C�X��V�p�Ҕ��sX�(�78>���<J~4��L������ˍ�V�"�q G��	ku;PFǗt��Hg��V�B����Z�:���Ʋ�=�Z�S�h굨e�|z�B��fca���99�+�������mm���Y>Eǯ볿����O�� �
��.ݹex����Qz�ҹ���ig�tR݄Q��6�J"�d�=/J�{���Ͻi��ӽ��l�����^���|L脥w�}��#n��ץ���w�e������3��y��z*>0���8:�>�~٘�bK��r�t�������k���)���=O���>��8E��tZ�������j��jjh#�?J�щJ[�d:A�� ��.���E%u�I�W���Q�qH�#�V�l����H�\:��G������/?�����,��%;<�5�׿r��~�x��������T��?K~�L^%gE���kr��~��#�2!��y�l(�3oB?=���nJ�m�}�{�~��2��XM������7������ty$JѶ���$�9��&�ߚ��K���W��<ǳJ��������{��)�G�`�~$���x��o� �$o�jF�?�����Ͽ�;�7$����{�������z���='�`�%�0�iX��@�y����~9Żm�NL�_Fa	�~N�is�F�����C��~��ӋU���{������x��.�%?1�;��a�=��ݎ(K���E�E�0%�����Rz�O_�0��r�i���KW�����Ч���g    P,�?+��� � 