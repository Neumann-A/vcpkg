#Every update requires an update of these hashes and the version within the control file of each of the 32 ports. 
#So it is probably better to have a central location for these hashes and let the ports update via a script
set(QT_MAJOR_MINOR_VER 5.15)
set(QT_PATCH_VER 3)
set(QT_UPDATE_VERSION 0) # Switch to update qt and not build qt. Creates a file cmake/qt_new_hashes.cmake in qt5-base with the new hashes.
set(QT_IS_LATEST 1)


set(QT_PORT_LIST base 3d activeqt charts connectivity datavis3d declarative gamepad graphicaleffects imageformats location macextras mqtt multimedia networkauth
                 purchasing quickcontrols quickcontrols2 remoteobjects script scxml sensors serialport speech svg tools virtualkeyboard webchannel websockets
                 webview winextras xmlpatterns doc x11extras androidextras translations serialbus webengine webglplugin wayland)

# Qt5 Repo SHA ef84b97bd57573bc9e94e8534005041597273a2d
set(QT_REF_qt5-base                2a2f3cd61f59ccec0eecb09e4a8795d7322edfcb)
set(QT_REF_qt5-3d                  72b026a22e6942eca4b70ba948022aecbd8965fc)
set(QT_REF_qt5-activeqt            f0d03da0e37a84029a4eae1733813521482ac1fb)
#set(QT_REF_qt5-canvas3d            1319e0965f6008f44f9216a7bb76e106a1710767) deprecated
set(QT_REF_qt5-charts              130463160b4923069eb98da49edaf7d93180f4f8)
set(QT_REF_qt5-connectivity        69a87a9b831e36a578594a0a13130c384ad03121)
set(QT_REF_qt5-datavis3d           c085311c02dd216e5a041b90c164d55b3cf3ce92)
set(QT_REF_qt5-declarative         0dda47d9f1a22567ad8f1266be2f0cd8a9226c7f)
set(QT_REF_qt5-gamepad             64afa18a0a1e9588060e2e6d917bb01ccdd48a81)
set(QT_REF_qt5-graphicaleffects    c36998dc1581167b12cc3de8e4ac68c2a5d9f76e)
set(QT_REF_qt5-imageformats        cb82c74310837fe4e832c8ab72176a5d63e4355f)
set(QT_REF_qt5-location            861e372b6ad81570d4f496e42fb25a6699b72f2f)
# set(QT_REF_qt5-lottie              fa8c8bfc6742ab98b61d1351e054e0e73e9a42f4) # no port yet

set(QT_REF_qt5-macextras           e72896968697e2a8af16a312e1560948e4c40f30)
set(QT_REF_qt5-mqtt                91efd3b1ebef3c95473c018bcacd0772e613b38c) # Git commit ID is 5.15.2
set(QT_REF_qt5-multimedia          bd29c87027637a013f2c5e3b549fcda84e4d7545)
set(QT_REF_qt5-networkauth         53870ee9bb9117702cd1f11cb1c5d1cfc2d5394a)
set(QT_REF_qt5-purchasing          cbf444fb570ca4f4ca21d963d2ae4010f10d473e)
# set(QT_REF_qt5-quick3d             3e3e53c834b25dc2959dd30f319d12d6f84ee1e3) # no port?
set(QT_REF_qt5-quickcontrols       cf3f6d7fec824cdf01f9b329ab3b92b1c0e0a420) # deprecated
set(QT_REF_qt5-quickcontrols2      a2593ff9cf5d0af885c20c2e9f9faa6ca4f1c1a3)
# set(QT_REF_qt5-quicktimeline       67503cdadea43b95ddad0de1a04951aff0ce1a07) # no port?
set(QT_REF_qt5-remoteobjects       4d6d1e35fb8e0cb900b5e5e9266edea51dc4f735)
set(QT_REF_qt5-script              5be95f966aabc5170f0aacfd4b0a46217241bfd6) # deprecated
set(QT_REF_qt5-scxml               7a15000f42c7a3171719727cd056f82a78244ed7)
set(QT_REF_qt5-sensors             921a31375f29e429e95352b08b2b9dbfea663cb1)
set(QT_REF_qt5-serialbus           8884c5e43df846deac5a0c7c290eeb633d6bfe32)
set(QT_REF_qt5-serialport          941d1d8560d1f3e40077c251fbde6fd6a5b0f0d4)
set(QT_REF_qt5-speech              a0efc38377e5bf7eed2d354d1cb4d7a0d5dc7e1b)
set(QT_REF_qt5-svg                 cfc616978b52a396b2ef6900546f7fc086d7cab3)
set(QT_REF_qt5-tools               33693a928986006d79c1ee743733cde5966ac402)
set(QT_REF_qt5-translations        68f420ebdfb226e3d0c09ebed06d5454cc6c3a7f)
set(QT_REF_qt5-virtualkeyboard     2f0e9f98c6c6fdac09f762d41fddcc114f64b28a)
set(QT_REF_qt5-webchannel          47be9a51b01d9fd9e7f6dca81e98d4eedcec6d38)
set(QT_REF_qt5-webengine           f328054d2eafc073b98a0246b2d644ee09c99d9c)
set(QT_REF_qt5-webglplugin         550a8cee241bbf8c11863dec9587d579dcb1108b)
set(QT_REF_qt5-websockets          e7883bc64440b1ff4666272ac6eb710ee4bc221b)
set(QT_REF_qt5-webview             920de5f1cd9f9001cfef1bfd2c19e6720793362f)
set(QT_REF_qt5-winextras           3df03dab21f3e84d5a7274c64dd879854ca1bfe7)
set(QT_REF_qt5-xmlpatterns         189e28d0aff1f3d7960228ba318b83e3cadac98c) # deprecated

set(QT_REF_qt5-androidextras       8cce1098c59534352aa0f343ea73861f603ac04a)
set(QT_REF_qt5-doc                 897e90fe304d844beaf694b82a93a50237fa8b9e)
set(QT_REF_qt5-x11extras           3898f5484fd4864b047729bfeda9a1222f32364f)
set(QT_REF_qt5-wayland             fcc2f57cefa66339c8cb6632f45a47fbb99bb60d)



set(QT_HASH_qt5-base                08bfbb7e37e227790f905b967f7c9b2927846e881064a4fc63a8ca64ae6498c6dff1fc6d7e440de5fdd11f84a1fc344183302db4efd24f0a6805f6abd93475dd)
set(QT_HASH_qt5-3d                  b3b1614151efa090b8622677e11ecc4785e519376c2c509027142ae981ddb1a112f505af720309f63ee40406889ad15e51f98af3710a9d11c79433c9403e3aa7)
set(QT_HASH_qt5-activeqt            5b920a5855eae0da91a1c242478b0ce0c0680e7c1ba597aa1af304ab9eeb17f2ba89cd8edf2f071f8f9efc0e25fea2447de5044a40b69f0e35f31632bcfc5bf4)
set(QT_HASH_qt5-charts              d0513e84bfb50675e83c3343f77593f44077d1a1c06ed53a1d9cc56371694aafd677f94d49306e60cfc51f7791f44ce9aa9e8c998a40fdea6b982d2a8aed6807)
set(QT_HASH_qt5-connectivity        c4b37a062daeaae3d78121fdbbfdcd55d1f7acfe2a922ac7b7c1b37b460e13960801b07780fe5915052d8ba554cf0f38a53115c3277671e4e16805c1300ecd74)
set(QT_HASH_qt5-datavis3d           f33a674f7c56627fcbffa3527f968c59c74983a2c7d4ce3ce3724432367abd0a7feb4bfaa5864b01f5639a40a2569e5bc861b0a35966e6aeb7570ffde7782681)
set(QT_HASH_qt5-declarative         8d3aefeb7911fed45a25cad2057299bbe1a9ea5fe22bdff660de979f332bee8bc6b7a8534f8b6428a3d0f42912e57178bdb669380f88d48ab6f9e4edc26ec91d)
set(QT_HASH_qt5-gamepad             2e6cec5d93ae39c39638b00d22491e91b043f4c819b66a0d95d0b05cee66f82dd8e440efc2afc193dc1a7d2c3979d1d9711d3ff0c7a384ac5c1cb27ca7995b78)
set(QT_HASH_qt5-graphicaleffects    d7b1308d2a1a7b346ec052d776ded489f7d6868392486b0e887d761093a271df3d6285ad62d6ab0c853846172b1a67d5a484d9672b2d4f73ef2f2706d0f460ca)
set(QT_HASH_qt5-imageformats        f202f3abcdea0b49ae4f286fd50c1855c8b84d502b89f8350666828c6e29c4fa0bafd72b891513330e2541dc407d298076ffb519a030b4bb50517b5196ff9a3f)
set(QT_HASH_qt5-location            b7cac8cd42185504c6140f1dcd4e8c0c749e3d8f22bf9977e97268e0ad6fbd3733e571a255ab7824eba31e30e707e804b07317f2ec9b7be15a4a5756c78c9e41)
set(QT_HASH_qt5-macextras           6a7983e252b6257facb21797896d9730944e0b621e7fb3b5e86c72954d860733c069fc56f077af4cf3f1c2ced139ac8647ead3bb3cc6318aa10831483a308b54)
set(QT_HASH_qt5-mqtt                91efd3b1ebef3c95473c018bcacd0772e613b38c) # Git commit ID
set(QT_HASH_qt5-multimedia          16876ac50e541911a756b3ad722f4ce7223169c68f10d26921abbc00161b4d3bb4eec19121bc98f57ef7d7056e976cbe6541484e6c8d8a8ec1cdb09cf303f649)
set(QT_HASH_qt5-networkauth         7a8297dcd699337ef5ac9feefc3246b81f962f5f8bb55353b4ec4ca9cd8591ff0370e733e5073fe4caeb17fbccadaa044dd9dee0ead122b6308a2f2ec9789ffd)
set(QT_HASH_qt5-quickcontrols       ca2d02bf01234a55ac22ff4fc5c1250d262acd7da273c796b192806b83ada57e94c8eb0eca68a1f9e491ac450f5bf6e6083fece9881883a92bffea1c9c6ce1fc) # deprecated
set(QT_HASH_qt5-quickcontrols2      915b873850d042580c3de1641d916f778da89f4b0dd7763254891fb48c99daece1c1c6888f9f8560d73617edce41e7ef4e712af965f12d29179a0bc70627556b)
set(QT_HASH_qt5-remoteobjects       4cccad10f068fb5825c70c5db3cd3a1bd4ea73b241fd1cec6edd2b7a1ab13f7800653e6f0f3157ec8c2e8c6162fad15761a5a138843972843b1d62fd3f9551fd)
set(QT_HASH_qt5-script              45ea77f9da631e5f908801d539b68048dd5b02ab352ef890d203d0adc1013b989f32b89c57a768cfb82d1d31cdbbd3b4596237497acde8c706a0975ab6008226) # deprecated
set(QT_HASH_qt5-scxml               2d99952208044db1405b456570d0a5e4d0ec7e9fd9aaf64935d81822218802f8ab6132276e52e4fa0ec4407f25e815a429c0b17c367665cb71a212c14b875654)
set(QT_HASH_qt5-sensors             4a01cdf5ea66fd037a79422b98642fb324ef714092888b251b912aa92fa09155509ee406f48b8d8eb5c27fed04860d2d085eda62b0bdb40db5e4b686ac65a73d)
set(QT_HASH_qt5-serialport          586f919f1e23c3b06c8bf1651cf2c9884f6ebf458b7abf135dc98cb4e55ee039b7d0513ab5941c386f70c6b26ae86fd0007911d700804651c68ea3938af44855)
set(QT_HASH_qt5-speech              290760fff67f9ccaf88bc6d9dd47e5bb968ae708a460b1129589cb5f9af5f7187f67e210f66c569943eb417aae1a55f11990489da6296c7ec24c5d0fe8d189a7)
set(QT_HASH_qt5-svg                 1f8b52c713b4c6d4974af46ebe6519ea597f72ac0c4b80e061f714ff30449e6fdae94eb9705f3c1b857c5ad0647e5875260ee40051cec78321caf7b944fd3d70)
set(QT_HASH_qt5-tools               9a62f1849c8eb65384d19de61cb6a08d1f467877181fd752e58b2b4e7d566c5d868c7ebab2d01591c6f540c01c705b7f8e0fe76c26cb0ee78f590ddae57048d2)
set(QT_HASH_qt5-virtualkeyboard     67afa86666aa6f55263053f9b9e76fde94232cd65c44b0edcc91f4f2c1866f699f60122b31a97d5e577b1d9986211fa5e1e0bc0b2ea86cec488a07a462e88e40)
set(QT_HASH_qt5-webchannel          7437fe06dbec2e649e22b646f96d31a676e4e41dd744012a6178ef1f1fb2cae3033b6417ffea9b1dc301fcb8246378291bcb245e66725e7cfd41a435a42396de)
set(QT_HASH_qt5-websockets          35b1caed6462083014bbb83c6aa81b441f67da7f0e3813fc47997ca4fecfe5423eaef5dd4ed3c37f42dd311eded0e6b36cce6725c7028047ca21b454ded9257f)
set(QT_HASH_qt5-webview             ebfdf785f64649c26576a7871553cd5550cbc86a84a86b6c5b3f2e206b70007125192027d5899f95c27479d7880ee57b5d2d39d2e46779c5376ea6ebcd9751a7)
set(QT_HASH_qt5-winextras           2e0def9771ece0d584ac310d0230a324b37604ba1a58f85a305b42c308560ef5fe3134d559c2534ac8cba74f9f159f86a67fabb00a20eae9f003f9914b19f14f)
set(QT_HASH_qt5-xmlpatterns         5a35408aa271beb4b787595fc40d8162f10dbae6fb80bb779664e8aa3c9c8c8a659c1d10e459854bda6f6f7a4ab2d5c748501f94cc8927ff8389e9998fa5d0f6) # deprecated

set(QT_HASH_qt5-doc                 a1141dc479d79c796a9e82d2bd66d54e6739b7dc2e3430f2f8bf3eb824a29b64b3e0c0bbbddb5656e06afbc52b5ab12c1e1ea89384416995b18174ea88654749)
set(QT_HASH_qt5-x11extras           3fd49498c92c37feb1d36cd94a76b37aade8a925efedd9f07046c7fcf1a0692e2f72d48c0b3263810ae69f5cd704cfce808e9714eb6a14fc0e228e05c88bf137)
set(QT_HASH_qt5-androidextras       9d78a92549934af03c9ade6ba0fd7fedbc54979707d1c1c7e78b391cb68689c5189c828c174eae2790cece5b952d540eb09b9acb98fc23d2825b4e5128aa25d6)
#set(QT_HASH_qt5-canvas3d            0) deprecated
set(QT_HASH_qt5-translations        012e83971a8064d87d0d7ea50e6a9579916974fdaef195f1eea1639673085512bd421ced7abc2550c5b07dad264c861a75cd8ae6d48ac1c5e78f5359ceaa61b4)
set(QT_HASH_qt5-serialbus           ffe33ec823e2b24e883dc6527986622ead64e509bbae481647095b9eecd98bc17adb0d1797163f9ff19077c46cf284fac57e531306437d3a263010b54de60b13)
set(QT_HASH_qt5-webengine           bdeaa27a1b1c97544620665a048a66015651300961524b47a8b94a206aaa9163c82f0b3b249dc8efbbe6de52cdd2d2e6c4621ae6ce7e886891e4ad9dfa569241)
set(QT_HASH_qt5-webglplugin         0336f992e1b8cc5457a1641f79c9d95a2c133c1644a86856cb077d6500aa73f7052533c235eddb742ea0a7efe75aefabe8cc776fd47a151136509cb7493f3061)
set(QT_HASH_qt5-wayland             c3da7a56d2b42a68a59b745a9f173eb3f9d46f19048b10855105fbe86314813906073e07a035e75f05e6855eddb88db95adec37fb09f0a79b26e2596d2b46c51)

if(QT_UPDATE_VERSION)
    message(STATUS "Running Qt in automatic version port update mode!")
    set(_VCPKG_INTERNAL_NO_HASH_CHECK 1)
    if("${PORT}" MATCHES "qt5-base")
        foreach(_current_qt_port ${QT_PORT_LIST})
            set(_current_control "${VCPKG_ROOT_DIR}/ports/qt5-${_current_qt_port}/CONTROL")
            file(READ ${_current_control} _control_contents)
            #message(STATUS "Before: \n${_control_contents}")
            string(REGEX REPLACE "Version:[^0-9]+[0-9]\.[0-9]+\.[0-9]+[^\n]*\n" "Version: ${QT_MAJOR_MINOR_VER}.${QT_PATCH_VER}\n" _control_contents "${_control_contents}")
            #message(STATUS "After: \n${_control_contents}")
            file(WRITE ${_current_control} "${_control_contents}")
        endforeach()
    endif()
endif()