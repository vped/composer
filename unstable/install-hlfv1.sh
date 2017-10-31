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
docker pull hyperledger/composer-playground:0.14.3
docker tag hyperledger/composer-playground:0.14.3 hyperledger/composer-playground:latest


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
� �X�Y �=�r�r�Mr�����*��>a��ZZ���pH����^EK�ěd���C�q8��B�R�T>�T����<�;�y�^ŋdI�w�~�HL��t7�Y�j�>���B��{u;F��k�O�L�#�0��BP�OĠ	�`(,>�pP� ��/ǲ�	�ۄ͚�����:ȴ4l���s�����Td�r �N���3�f�P3����-�;|�j-X'e�^�:�֑<S)��Ʀm�$���;�K�<ge��h&6ZȰH���Q1Y�?ʥ2�]�� ���'
�
ͪ�����-d�*�!A�����.!H���Xi[��A�2�jK3��ab]�+"�D6��;*���Ģj�bm����n#C�7�a �ŝ��~��l�<��6�c�4-�`�붆^�SS5��,��ڶ; ��H�@�U�/,�`�*�����z'P/��d��n���C�&�W%��A�Z�Wk!��a
�<lV�ITn����!-�ԩ�u���e?�����hv#BH�?���bA+TW�(�AG��jY�L��92�b�x�W]l��köۤ�*�cBw���2����n�m0�m�@�k����r�pl�)uafK���&�e�-��'���ʘ�����x��>g ���&�W��ݛ=Х�Lꃹdr����r�{�|�z`_u|t�'zxp4ȋDB��?
��O����d1$?��d|��ߌ�	�p�p�W�ո/6����/J1e��1"K�u��
x�C���
���SE���j���j&����uL)�(���[�}��<��G��Vɧ�Cle��}�f�?�}:��������Wk���a����ڄu俰�� <���<w�O������C�@����z�o%@���Me`ȱ1^���[:�5��62A��Y�ƀ���lـ6�Z��tܦ�b$�l�vL�2���M�m*�m:���<�ll������f{�� �,hɓ�S�����=Jc������(�c7�9���j��隊��V��4�O����fY�VG�~~��@ʊ�զڀ�];�ºC;Ԣ�����dk�܊��U4Ն�a[�|�����������ČG�"��@md�ŵ��1��R�c���X��~���D�<�is����D���~���������?E����}C�%�D�R�/�b$$s)���o%0�q� ��@�1�f>��MM�4��D-�A��1ͨ�^
Yܰ�e���6w�q����V��h[��q��j�-�&�EA��x�EI�G ��@�Qڐ��ɇ�G�g 
��=LNF��i��4��s��r/�F�߆��� ��(�>��԰�x���d��"Bb�c.
����O���\p��"�5*��.���i�]�k;�Ca�l�b2�fu�#��q������4z�u�X�z���I��'T\�t�bE�A�=rAB.�h6�De�b�g7HG�8�q1���ZXHG��Mm �"�3�9����Ŕ�Xg#��u2^����y�z�:l�� �WD��*e��p�[����9��b"�|�j�8�y��vͫ��h]j�W�,�rUl�������*҃��P���O8Y��V����f��h,���'F���#� �e �Q����I��>����l�fF�G�1�<G�ݴ	+n��&%@�	~������'x���)~(�����/�5!�����voa�|�z�����be�	rSJ���8I���܋��(j�b�	�Y�1,d�$1��(�������d�=�P�tͧI(ҕ����GDX�P�)o��JJ�l�\�/��,��ز���}�	��Đ��h���
�����P���-؜�x�O`�D��{0\���r��� G"q�UA&~�QzŢR Һ�O�4t�C'�n%JFԯ�<�m��i� (���_�6���d�`��J�;�w�����$D���j`�}�0s�M�!���?(
��?
������=�԰��n� ����k���]��DN����׹7̰�����<�~�3"�#�󟫀��ϖ8�҂e�����_DA\��*���C����Hpj�������J`��o�.ñA�ed��|	ڦf���VU���%�u�l�l����G��qJ!����æ}_���D�O�'"d��f����.�}b�,� =dD�g�� bx��	�I�z�J�b��6UB/Ǻ/��0�B�"Ry��i�X�:=$e#��>��4~�lx���Bl���=�<�1�i�;]��*��	����w����	�	�ݧY��]���� ����9�l���l�'d1,������_����"�H��
�����a�����񮂾>p������ρzO�=�	�'�p�
"�s�
���;���ڨV&�,����},���<��O�B�z�w%���	�YƖVoؠ2B��~JLx=0#���J�����Zz�7��?(ʢ{�C�#�������������"˝Y���!�{ �u i�0���aւ� \�I���<��ڞ� (a8��Y��,`�4�5m��B�����$�R��[���	���Mݥϖ23Eɵ{���F��l[��d�K�%��wL�蘨#�/�dB���8�32lL���9c��t��Y�1&*��l�T"�����l��0����)�r���Ⴢ�s}���wLf�ե�����T�O#�ý�y7�ثCE_����:�z�x�O�q��1�����;��ȉ���o_.�Ax��_!���?D����o��߷���w�~�����?����������?�`EPeY���TQ�(�Uj����k��$K�d�a9Z�e��P4*V";!��
m�Ƿܟ��	o(�����n��_H ��m|��%��6�|��qqlXش5���O��mf�Q�����Ɵ��$���|�͈�s�c������b�|��d����S�,^Mk�7�����=m0��p~���N��=�.���Y�{'���)I2]��X��U�'��0��mx,�������z�%p�����ҥ�V%eÕ� )�I���5�~Р���'Oo�6�,�w�yK��}�[��=�"�2�E��Fv��Nm'�j�\�Q��DA1ީBAʂ
ŝ�V��Q(ˡa��]�*"n�Fg��X2�Ɂx�Pʤ2q��d��l&O_���+�LL�g
J�92Nr/z�@,��o"N6�|7^?����Յ�$�]�*yH((ʹ"���F6~r��L^)�X=wBH���\���[��k�&/SJ�}��'�K�3�V�9���3i�2]R޸��LG{�WI��M�Qy�΋���$\�'��dKI)�xg�fbv�j.[R�����-e��RF:�e�L��3N/b�l����g��|>��>)_%KY�q�u�X� /�,xz�Q[��Y)y���ݖ_fs�r2����i���]T���lL`J�{�?-��4���0�Ő��)[M_ꇭ\�R�����eӱ��t1+G�z2�{���}E�(���spˋ��e��=���H�vvpz��	�����ؾq�<=��r�()X-jZ(9������\1�����B�\N�����E�;�*2"m5�M��<��zB�Ҿ�/dcJm'�\(J6n�VU3�|3?P2��y�H,��3��a�{���n���#S���YMz�'Z�d<l��"ԕl����u��3����J��;�*:����H"BE��=�v��@=S/�¸�{ݫ�N�a2��F#N���$�����N5W.({����\b���~���p����f4�ǌ�6�O�D�l�0D1,����䙀��71��-{�+�O����}4���n�V4�K��A���(�R���Vcq�q!sB&p�<c�O�l&�O�de�K]Hc�|�.���a� k��֬��r�GʉPߠ\�T�;z*�ԫ�Aސ�	��R0;q+_���r�*�W'r+��T��'�r/_�B)��'�RZ���Fc�t$!	�J Qvz�����Z(�m�l�)7��n6�s���_��/ߜ�C������򹛾�'_��/͘�C��+����;��ǧ�T����{�q%?�
I(y5��+I��T�K����Ӻ�D��ކǭ�S��S�f�N���s�*D+��-6�l�n�qW<����o�R&�����>-����|����6�KjZ�߃����%�������da��e%��q�g�s��X�|3�~��:(�2Ӌ��{FOY'��ݴ�>w/��!s���<��{8 ��#�ґY�x�	T�����5z��ې�@�Nӟx��������C�4&�i��%N�y���؏��8 ��-��`�|+hޔ"_l#��b!@_;�^��.;�D]��l�L?�4L�я��c�v!�ӝ�W�A{o���dۣ��@���ߺ����ȏ4w�x�c���/��-=Gk7X��a&Yd���^D����f��S!z2�g=�=w�vL�W~ ��/�@�^`�B�%S"E��H�A�t�ѥ��aͦ ��i�eH�\��!��N�9`T֣�-��DP�.d�Ы��=��8 �
裣���6(5���/�Q�%��ay�^�����I�a�Ս�#�2���d��[���G�{���Ԫ���!�I�u�9ҾXo��b/���&	�N��B௯�����~����~�_H��M[��ҷ�;��5��0��C����JĄ<�/���6U��{�GS�1o;=�5�I��rE����9��6e|�	��ءql�8\k��G�UA*�ȱ4b�Bpf�T����s.|<�BB;�݋�t "5�6��JإH��[�5;���<�L����7�DǸI�jM����*����cǰ}�@�ΰC&���.��n�8*!�	����ҽ�M����F]��"����94}��>�J]�m:��ҧ��5�m��	�0��od�]gH;�&�n9�C;�8Uw,bE�W��:�
�=ϥ���)wX���Ni��c~��&�e�N�� �C���jCzLx�F��z$�)M�8�ۮ��ϵn��� 4,��n�,�O�O>f�0��c��fN��g�Zb\��rwO�ɝ~pa�p��F]��Gl')�Jc�N�T���dQrb'q�<*v�$tY �h	�����Y��alF Do���s���ǭ��{Q�iu�*����:��������9�6(�ְ�n�wF���Ʋ�@;�16w�#8ܭ�b}s�oW��x��\������`��_� ��Iȣ��H�K�G��_���_|{�W���q�gJ����/��߿��o>�������8�}Y"�v��{�?|��G+�6�u]Lh�g�%�H,��2&�%JGU��"d��D�JS4���8E���R1'�#�����V�a�_�տ�r����q��_������_P?|�?���`����oa�� y{��5B�A�{�؆�����w�������|�|M,B�� ���?=@~�ŷ���-�C��b@�ZLzh�"�i�{�X���3�J���r�)����|�X�>��*��*\��UM�m;�{bq?��o���A`-D�A�3dFFMZ�"�b��X��"%����l�<+��1-.+&� ��W%�$Z�34��&\���4��ek���R�J2�]��p��-�2��07i��XXIf8��=��";���n�R�Y���bɲR]��C�E��(S�3^�	�n�\l00���if���y͢ߤLK:oL�S|e�zB��膮�L2�)�J��A魒�ܼ��[s5U��vF�'�:b�8��V`�i�e�閭"����=?"�H!l��X�3KN�� �ي�@�Y��n���M�<j��4a�3�9�χH3CY�1IϋB}��6F�NorNnc��]e���崏ꕾ�6d�+��"өձ������LJ�k�N��nBH��v���y�\1KLjc�-��`z*LT�G�1V5���l~�]����t�%r[�%r[�%r[�%r[�%r[�%r[�%r[�%r[�%r[�%r[�%�py	c��"o��z����?\�(e��c_��󺄗�l�ӹ\�K��rW�/E��)p!֔�b� �sՃ��b�qcՃ �s3���v�=�����7S?���Ϊ@�FX)��"��7�\�Ԣ͚Ti���<)��41PZ
ab=�h����LVd�Y�t%^�Oqb<��r�*�W���?ϣ~��1�9N0q��x���W�<a�d:/3������@[�^�ܺP�d�����qd�'㴊I�KYy��pVrԨu�ڒ���NS�F�9���B�S�ӪFW����]@��ɝA���c������[���ۡ�;z=�a�(����G�=|��r�?� ���u�޽���o�}y?�܂K�M��9,�u��}z��k�#��?D�|���uk��ţ���
�}y3�F�5�������Q�����H�#W���x�'���GB?x���{��ϯeٕ-�y��36�K����2�GKuZ�wt�,�h��䘲���6߷��#X8ޢ �CɅ��jm��I.�&VsPr!��*Z|�]��-��"[�$pߠ�� �&1�m��B`׊CdY�1��,���
O��3:Ag��IAM��H�.������Z���6�
M��צ�İ���I�2M�1b�ڪ>Lf��0�T�x�B��w�L�x���'�t{9-�������� +1@��Q1iA�E�M�r�_5�A�S餎��hԔS�s[-�\#Y�j����SdCQvsi�cyFc����.�*�a�$�%��mAt1����b��銭�>��"���;R{��7�lM�gH�-�z�.�hop�=��7�d�0�[��\ldPA���,��cټѝ�J��?y���"������rr�T=��z�~D|�b�:'��k,s}~��˜>��	�3�fU�|�cw���;m�>�p�g��A��ϊ��p$��\e"��bZ-Y0�]Y/dD#eH�\��G���ˢǃ�V�L��*9�H�-eU�i���8no�΋B�ŴD�6s]n��r"o�Q�*#2�c(󎡜�:u���&��0f���B���b����b��;��h�w~j���v!�ʹP�&RqGU��
KE�ǈ��]��T��fҵ�TQ&|��g6���|����T�l��rK�S�A"�	|��GK����>�`8FH�"5�eVŧ�e��<���"Y������Q]��D<�f��w���V����*�Eҳu�G0bʂ�����L��|�2��혧LJ���
��^�PʙQ�X��O�c���)P�zm�ǧ|
L���tjDl�,��.����	.�L��ȡkf��W*�j/�W��\Cb��h��*��({J��mH�c�x>ZY�����U�f�h�H�Ub���@&Ŵ�%y}����V��x��P��b�SJ��4%�^�/
�|��:A���|l�0Y��ʬU^4��<lY"K/��
k�(G�K��l���<���˘ɷK#k���C߲m������;A��/D�v���D�&��6�/ \[���Ts�������ip�����!-'j��[ț�X�Y!?��f�W�Vj����G�{Ϟ=�?z�,�����#9��B��D� ֞>C�΂oUY�Ǉ�m�@\ӛĕ^)�y�y/- d-�w�vE�!0�Wd��|��,'��[�?qΦp���N_���{��0�2UC5BT�!�}
~J��.܋��Y9B^s��O�I7���D��z�_�����ё�d����w�t7�_��>~�	���Gݿ�9��Q�������΀ ��V�|%ܳ3����#�E�)�*�O�<TM�.v�����Uo��f_���'0���ϕ�)�3��U?��v�@��wN�o8Uald�ѥ�e�p?[���o�Y7��~lݭ��V] �_��bN�t�dO�~���=Sx{��;zWD]v A'���i\
"A@���?����� � ���l����P�������=��]���4{�@hg����ɣ�m1�g�uA���^:	�3l��3]	�T[g�A`�[��_�9�՚����/���h5���-LH8�4�?���]�	v�0� ���Ewz�c����[G�>�BP�:�:�k��������j8 �@�X+�� �O^S���Uؙ�U�r��öB��D���f���X��٠�2����ƥ!t��|Mh��D��$�!ۀ��`��m2.}���In-�mX�j��6���pil�(�"˗���v�Wr9�|��B���?Q�g}a{��u]�a�Q�7��k[��્U �v=l*t�둟- �<��	^ ���z�ڿh�z6r�-> ��ŦB�4XZ�z�.�dp���!��{P,��̡.̍��	�l�R8�1@R��w�q��$�s�k@W�g/"��B�m��r~ض�G��Oae�%�{%k��ٺ6��F�8��/�}��*
�q.80N�� ��.���e�a�粦;�1��8�x1��rg ;�S�	���i��r�9�q�����]x�v�1���C��B�~�i��p�{�m�B�p����BN�Y;8Hv�nl���v�a�(X�Hp�ו�:64���N� fv(/��l���ډ:�C��@�p�nm�ƴ�y�ٺ4�.M{������������ୃ"�zu�ɺ=,e��uǞ�E�ۄݲ�p<�`�
��[��7�_�����m�M�[o�V���Z�h����6��L�o���n;����v=!N�O�9|rh���@=��5�5�n9/ �C`��ueo*��%���B�����M��kkKL�D�	f���ı8����y�i�uq�/:�������45�ܿ���8�6�H5��t�ʍMK���-5�c�Qr@qFw��O���j��c�������vC�\�����(Y���������!Xq���" ��X%{bn8�S;�F@4�9��Y߳N2lIH�%�3�)��mtou.M�)X�KU�~�1v{:�||Y)��,)d���z׺Y�c�p��D���S��|���ȝE�YnQ�8��TD�P���jW�\��V��?N(�N��e���2A�g��d@�.�?V�0+��ǶJ{������q,��c��0T3�ڣس ��9u���U���MɭV#cXT��P�6&�eY�i2�F�S#rK!$�=���JFU\�e՞�������X��ʧp6��6T��}�s[FO�;w	��dg�=�}Tlgܷ/�[~O�+8v_���6_���M�)>Ǘ��Y6���U>�TQ[���ل����+���SZW؅���e�,�R:�=�G�Wd��^����.T�Ɋ��=�]�D����Иxg]�\T���#;S��:��hw��Pc�F��ٛ� -���&�z*�0:�2:��=���.�zӵ��9���0Q�:����٭�? �O��\L�;Q>/��D��"O	��Y��K[��'Ҍ�K�uN�'8���6�V�3>��BNz:i�E�=kt.O��l��VO� }��3�"/==
����لGK�}��S�h:_��\RH��x��/����zlt������8����N�FJ����,�E๔]�,1����a�2�4B�r�%��J"ͱ�ܿ�	�"�R��B�����Q��;{���ӎ��,�o.�7��]��>�l�������͢��m?�o��ۅ~L���
֮�u�g��{���w.I a�Q�~m��\��ɻg����p�8�سJ)k7�8B�*8*:�~������]/��]'�M���$����_�n���<��������m�G���酯������Gp�s��w�^	��������}�t��o�F[�I���t�t������#��� �U���m�*J���C�C����O/{���P����8�|�ݔ������=��{���@�B=мl�~��J�Ԟ�_���Aҡ�?U���.��b1��)�-;HSZ��V����JǰX'ҎP�H+J����8I��3㮨�^����w����_I�o;L�s���:�umdj��^Ag�s�*u�Ѵ�4q����B�P�ꜗ��j�s�S�[�0��Ӎ95�DT"k�M$WZNk�������y�X���i9��O��Ҵ���W�uY%zT�.����K;�}z������Kw/�l���}ڟ��79�ǣ����H���'�=���{��t(�6�e�+������wm͉�]��_��[5r>\�U/'�|��'PT�_�jҙ�i�I:݁g:{]YN&iEk���z�����;���8��*P3��&��~>5����k���ž�@�W��i�6.Q� ��������Y��*��?���D�CU��O�4���?IC��
�Q�pT'�����) ����0�Q	���m���s�?$����� ���?�� �����$	����k��u���͟��J7�/x�m�]�1��-���ϲ���Аҗ�O��������9�������~b���,���ɬ
��߷������,�`��¯VyC+��E��z�E���U�9�n��:Q̅�*�:_G���Z�a��
�E�j�'����=t��2���ϗ�O�G�>��a��r5���;���.S,R�=Y�$�����|������/�es�.��Wc〝~͔����F��r>�i������'��eX�4���Ploy���?V{]�"GŬ���r����H�?�����ӂ(X � ��ϭ��������R������'������O���O����	��
 ���$���� ����H���g��� �W����A���@����������s������s&�S1=�s��uk�X7u~��+������KY_x��Ő����^��7��4 �Z����6�]p�vÍfc�ϴx�Q]V�2��pz��{���!���ow�1;��Sidxh��C�45*뱿���h��S]�>�Ȇ(�sI��d��R�/m|쥏��6�}��CK[�:�����tJ��Ӳ�b�m���v�XSn/��d6���m1�Ιb��EhҒ4�WL��QC+�M>���1B:2Fsj���o@B����
 ��V�%?���� ����(�?��g�)���� %�����1q��1<�<�3�DxD|��!�K�,�T�TȆ%P�pF������5����y����9��A��4Y,Os��/�s��u*:˖1��A[���o���ޞ�������Uw/rv$䬍M=o����)ܦ�͖��|�)q�����>�D�,Ț1���������(��!��>�|�?���[+P��C�W�����������Z��f|B���P�Շ_Y�MKu���8m�1����Y1Xw�۫�v�yː��<=��j�b��H�̈́��K�v���}�l.�ya'�,�=_��0�)�*��n\օԙ�=�l�������N7��c��{+и���������G����P������ �_���_����z�Ѐu 	��qw���@�U����W^�_�~�����-�~t�L��Y!�D=O���g�Z��Kq�����s쪶?s ���O��}�g�p��a{���C���x� �:�Sz��b��;��^�[r����4ZMI�Z��]ڶ2l�eH6bs8�q�DTg�1�~���s!xW�f헂y�n��X�Y��8��n9O�W��`�-�0�k=��b�%]�'&.�p`@���N3���>�$%����FR��b���I����I�zn����e-�!���ڛh��KMʘ4y����B�P-YSG:��Y��ώ�2�өޑ�d:W��K��n7��|����fd�}�"S��>lR�C�;c��Y2����r��n.��h���#����W>���0�.����������'��?>(�?�?����%���!�YT��?��;������C�?��C���O��ׄJ�!���A�4�s3F����>��B��<�G��n�A�I�x!����Y?���
����_�?��W��z��*��e������h$�g�,腹�%ktj1ї�_{��,V�.饑n���w��(��vCI�,��I'Յ�ߌ/#]z-y�;��Bo���k9�>NmZ0��V�p�'�����S	>��ou�J�ߡ������H��� �����0�W���I �E �����$y����_E�������B;T��?��Nq��U�W��o��P�:�m�ۑٸ̚R��N�$UWk�n�;,k��VD�e�[%��3�߷簟��������.��5�1#>�TK���w���g�"ګ����w��I2��K��*l<t�Rg�[�G�z�Χ�.�-f'	cp�e�6���l0d=Z���B_:��3D���z��s����vb����f��GN�$�{�B�첍�����q��	�e:��鱗c�P]Y�d:�-��x8ӈ��R`�Bs����1����H8ɳf��6�����^fi+U3_�
C��66���'����t�"�cٕ�wU{p�oM�F������ϭ�P��� ��&T��0�P���S��W	`��a�濡������a���$��������}������
�����R��U �!��!�������o�_����1��Һ_'�1�����i��+
�O��}�O�W������?���?����ׅ���!j�?���O<�� �_	���������?������h�?�CT����G�h���� ������) ���;��?*�6Cj���[�!������E@��a-��P�?��!��@��?@��?@��_M��!j���[�!�����h�?�CT$���4�?T�������z����+�/Ob��P�n���?6���p�{%@��a��r�P���}�������u	�S@B����
 ��V�%?���� ����(�?��g��(�?A\�`�G���)���B4���"�`X~��!E�O�/���O����G}�_���K@�_���Cmt���OW�/��s�8��@�6^�7o��b׊^O�Ӥ)$��ż�8�mb���z}Z��(,���%���hʢ8ܟ��r�af�����\��y�6�(���ʽXC�´��:d;���x�����bSq����q�hI�"5䯥�݋��G(��!��>�|�?���[+P��C�W�����������Z��f|B���P�Շ_Y�B�`΍C�)Z���a�Foɝ�`V����E·���[�K��D��}��f٤�����,Yk>Y��y�|-��Ĺ����(�a�\L�s[�v�2�Sd֌
�ҵ���.�1��{+и�ߝ��oE@��������7 ��/������_���_�������X���/�#�����5����k����n:�䱼g���ʗ'^���7���W�gmw�v��I^�Ȃ�c��%��z�~�9a���V���4b�C��L	v�D��ph�'�݋�,>��c}�.Ų<�9���%��lF�����fn����v���;}��{�t�m��r[RaH���^�Ֆt�׉K��^]蓾�i�� 2ۧ��<Q��H*7���9�Sv?7iW��B�P-Y�p���	����D0�T�ϴ��<��͹w����(4ڽ�����'3��
=?ՈY�Z3A$�8�L�Ft�Q��|�1�����+����g���[����_�&�6B��C��
|������^�o����J�B�G��?a��|���)�F��E������I��W��ĉ��/�_����\O��@U��?�p��W�g������#����5��0O+�N�h�ԛ-|ʸ�����?Z�h������Ҵh?;n��W��J��{��0�œ函�܏����Y�����Kߐ��rx�.o��-��6�d숎�_�VM���T����Q��Y#g��@���oTa���U�ʹ8��ɳl-&ղ�d��{j6��#Lv���hѦ�%<%_.�)�G�?�h�'+��}�/�����R<Uo�EE��~��;ק�NӐ�>3%�I�8�7uvTC�v۲�#b�o+�i,#�*{l��F���e�͎�H��H䢗ؼD�t����`f���9�d"��i��k����n�Z,%nӗ
�<ŏ�&(�=��ԦB�/��c��+����~/@B�1w������?.`��%(?��<A��0�B¿>M��0�i�zß�C����Oq2!�GxH�`����B�?��0�W	~�����s���� 	����l?���<F�s�m>#�}����+ߪ�=r�V`���������}G��!��� 
���{��_%����¨��������,�J���+o����������4��S�v6��?ߩ���֗�:�`���������[�9����w���7xCr_������b�ao��,*9�K*�V�;�2�m(� j--L`���τa�7�L;�d��D_��(o�(̳vq8{����q9ٴ�q�e����������~����r�Hb3NDw�nȣ��v���|Q�-;]�Em�*E{����$���v@8w��M8z5�_K�g���oVnb���A�ṥ̉�B�Fz5�Ӷ7֖]�j��n�/�X����P����������0by���9O���_�^1\̓��	��y��_«��C�$�\�!x���Q���q��bq������ku�M�&"�������΂:��z�L�=��P�3+��������Z�����ފ����~���q�_@A�]�޽��A�U�*���m�NxD����u�?�Շ���9�AȠ*����~W�s$������|��<�њv���n,���|������>�!����!i/����w��jb����IM�-�y����D��~޺���PԮ��/��I�;�N�t\��$Fa߽��k��麏�#7���X[�Υ��~���&��Xnզu!�����=��^��{�h!>]f��o����\a�KW.�����a}��Wۮ�e%���u�J���Ǒ;�w❭�:Or*E��:�պ��7էRq9v�������'3�%���JЌ���Ϋ��bY��ӟnT�%F7Jx�\�K��?�����%��ς���s�x�oѾ��P�]o�w���ٱ�iڂ�2l��yd�Һ*��O����ҶMcR��ld*��r0���gw
Ɨ-9Yk�YKl�{��rvm@U��d-��+�,g�!��~�!�
N��@��~E9����4y���[�C�O&d��8�y���������:��������?�2�g�B�'�B�'���������p�%��߷�����td��P.g��������?��g���oP��A�w��~D�^��U�G������6�B�٫��P�3#������r�?�?z���㿙�J�Oエ� ��G��$q��?eJ������G��ԍ�_��,ȉ�C]Dd��_W��¡�C6@��� ��\����_�����$�������r������y��AG.������C��L��P��?@����/k��B������r��0�����?ԅ@D.��������&@��� �������`�'P��kC�?b���o�/�Oݨ� �_�����T�����d@�?��C�����g`�(���y�b?4��G���m��A��ĕ��?dD.��`H�0q���iͨR$��u�J��ais�\�M����A1�e�U-�BS&^��2�3���Gݺ?=y��2s��C�6���;=y��E��8���R��E�ŷ$����-���_��׉��%<�Ncݮ�0ǵ��e����*����I�U�F�|3��o��ǝ��-�j�$yP��"Y�7�JT��ھM�%�
�\��]��i
�_�zk���u1f��f^y����+�u���Au������]]��y����':P���
f}�@���Б���t����>�n �V�_������{��f�Hi[�u�qi��X�6�I�0�q���j��m\_l�i���5�Ѳ=Wۃ�Z7B��o��51�i���R�F�U�R�m���(�M����ӋC,-盅2��9��B��$Dڱ����R����a�(�C{4�Q�B�"���_���_���?`�!�!���h������������������qX"��zVq�J"�g����O�����k|��ID�/�O�@~��`�z���e�o��q��q�ݟŇ����cM�ۺ7)��܏�+7l�[s�X�jj���d�i�Z�ܴV�<(k]m[�D�}ء��B��G���s��駬c~��?�r��x��쐷�:�5j�i
ɔ����w�q϶���D '��b��D�ƹ��|�M>��'�6_�sE���G�݄At%���YUR����1��um�%O{~��VbQ��z�P��$���b�n�UR���ҥ�a��!�Z��׸����|�Ƀ�G�P�	?����=rJ�������8�Y��go����Y�����x]�����������i�����JC� w�?�?r�'n����O& ��W���n�{����S7�? �7��P2{������x���������P��~Ʌ�G���/���$R���o�/��? #7��?"!�?s��K@�G&|6��x���>��qe�D.���Ud{fnW�� ��#�w_�?�9��X�}[���9���e؟��8�~`_��;i��K�o���{���,�[v�~���z��2�kAǬ/�X��P�]s^]j{����Qt�xg�6�ᄵnQ %�~FqQ�'�b�r��Ni�ط��^�~�y��.�.ϕl�ZRQY6�$����P����3�����5��y��;1��D҉�3\�G>0',���ac�^�F��01�fzԖ�^xԭYD��=ӡVfq����B�J��Z�K�Af��������d ��^-��-������˅���?2���/a Sr��ߨ�E��&@�/������Z����D ��>,��)������˅��8�?"r��7���M.���G����Z��������͆sד*#E��������}�?I$�2<��uoe�G�K��� `/�y�P�E�zuw����H�Y�k�QbX_Qf���o��T%��-�ͨ���ί��>�zN�<rJ�Q�7�L��}cQ����9 �)	��� `�$�?��%\��d{�\��p]B�v�x1wL��l�aGYt�Qu�;��w����Z��C���Ks;M�,���D��3LQ�&DWMt�����o&�qc����	�������n���������e�F��2��G��*�Z��,F3�jE3�e\'-�J'h�"I�R5i°p��-�6L�e�j�%��.�Q���L��������s��;c�.�U���,`��HBՈŨ׏&�^[��usW���?Ń?!K͝]4�P��V�c)����
����8�]�4u��+̱���q�Qbw/����Q�%ѲB�I�C_t�	����������@����B� wN���Б���d ���E S7uS�%y�����=��`�]��E]�H
_��X�����W����U�;-|������c��2��|�zԪ$$�SsLcA|�#z��G�� ��A����S(fܖt��X�W��(8��UdM�E����������Y
��,@��, ��\�A�2 �� ��`��?��?`�!�M���C���������ߓc���u�Y��x���������=��o��.��(.�h��D&�hZ�(�lPT�$R���VӍ�S7GU�Hͧ*�,��Ŭ����O�.��buhi��i��7�ʬ�n��j!����fv��x�K�;��V��Ly�;lp�iL0����'-��|�VIdz�%{�*ɋ��ReA/����h�1����x�)��x!=_�7�r6QV�KlHO���m��"�I�@�$b^���S�H������xF!��ae��5��D�ۻ�'�hc���j��0;b��#Rq�fcfw��)�#��*��3�Z�?�}}���������?N���G�ORE��g��;�M���1C-6/��/�w��m�*�>�øP���,��һ7h��3�a�����pA�[��,/wN�l*H��DnTx�q����o,������Q?m��#
��y��r(!4��ys�}P��fz�.��Z���|>�?�/}�OOI\��9_����#�9��a)�,��!Ig��ς��WIw���E��� �ݸ�{���`����������Ĭ5o=b��]����F�9}��ӫmhb\Oh�򟭧�S9Y��td)��B�c�fz���{���ɽ_޼�G��N���?����<�o�뷇=A�_��~{S��7����$��UzT��#�������;���߅y�"'8o+<X���>���^�K��p�mPx���>��v����8f�2�ΏS!��OW���Zzx�:7}TH�T�­繞]X�����Yp�hk>�������~��JO��m׺�f�_x��}â�i��5=������<_sz�QL3���&^;��o_�/�C<����bqO�Sa>5wɌ����J���ȟNV�]��N)m�W���U<�7����:��{��w��Z���N��$N	��$��?���o��a��}�?���n�t�?>�ﲏ                           ���|�� � 