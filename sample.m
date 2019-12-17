% とりあえずワークスペースを初期化しよう
clear
% ObnizのIDをコンストラクタに入れます。
ows = ObnizWS('XXXX-XXXX');
% Obnizと実際につなぎます。
ows = ows.connect();
% Obnizの液晶に文字を表示します。
ows = ows.displayChar('Hello, Obniz!',true);
% ２番のGPIOに５Vを出力します。
ows = ows.gpioOutput(2,true);
% 0番のGPIOをGndにします。
ows = ows.gpioOutput(0,false);
% AD変換値を取得します。
ows = ows.adStream(1);
% AD変換値の取得を終了します。
%ows = ows.deinitAd(1);
% ObnizWSを終了します。
%ows = ows.close();