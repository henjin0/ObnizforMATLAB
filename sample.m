% �Ƃ肠�������[�N�X�y�[�X�����������悤
clear
% Obniz��ID���R���X�g���N�^�ɓ���܂��B
ows = ObnizWS('XXXX-XXXX');
% Obniz�Ǝ��ۂɂȂ��܂��B
ows = ows.connect();
% Obniz�̉t���ɕ�����\�����܂��B
ows = ows.displayChar('Hello, Obniz!',true);
% �Q�Ԃ�GPIO�ɂTV���o�͂��܂��B
ows = ows.gpioOutput(2,true);
% 0�Ԃ�GPIO��Gnd�ɂ��܂��B
ows = ows.gpioOutput(0,false);
% AD�ϊ��l���擾���܂��B
ows = ows.adStream(1);
% AD�ϊ��l�̎擾���I�����܂��B
%ows = ows.deinitAd(1);
% ObnizWS���I�����܂��B
%ows = ows.close();