classdef ObnizWS
    properties
        strID
        client
        retStr
    end
    
    methods (Access='private')
        function responce = getReturn(obj,tempFilename)
            failCounter = 0;
            
            while(1)
                try
                    responceStruct = load(tempFilename);
                    responce = responceStruct.message;
                    if(~isempty(responce))
                        message = [];
                        save(tempFilename,'message');
                        return;
                    end
                    
                catch
                end
                
                
                if(failCounter == 100)
                    disp('Can''t get tempReturn.mat');
                    ME = MException('MyComponent:noSuchVariable', '応答がタイムアウトなのです。');
                    throw(ME);
                end
                failCounter = failCounter + 1;
                pause(0.001);
            end
        end
    end
    
    methods
        function [obj] = ObnizWS(strID)
            obj.strID = strID;
            obj.client = SimpleClient2(['wss://obniz.io/obniz/',strID,'/ws/1']);
            obj.retStr = obj.getReturn('tempReturn.mat');
        end
        
        function [obj] = connect(obj)
            num = sscanf(obj.retStr,'[{"ws":{"redirect":"wss://%dws.obniz.io"}}]');
            obj.client = SimpleClient2(['wss://',num2str(num),'ws.obniz.io/obniz/',obj.strID,'/ws/1']);
            %obj.retStr = obj.getReturn('tempReturn.mat');
        end
        
        function obj = displayChar(obj,str,isClear)
            if(isClear)
                obj.client.send(['[{"display": {"clear": true, "text": "',str,'"}}]']);
            else
                obj.client.send(['[{"display": {"text": "',str,'"}}]']);
            end
        end
        
        function obj = pwm(obj,pwmNum,outputPin,freq,pulse,groundPin)
            if(~isempty(groundPin))
                obj.client.send(['[{"io',num2str(groundPin),'": {"direction": "output","value": false}}]']);
            end
            obj.client.send(['[{"pwm',num2str(pwmNum),'": {"io": ',num2str(outputPin),',"freq": ',num2str(freq),',"pulse": ',num2str(pulse),'}}]']);
            
        end
        
        function [obj,voltage] = ad(obj,adNum)
            delete('AD.mat');
            obj.client.send(['[{"ad',num2str(adNum),'": {"stream": false}}]']);
            for i = 1:1:100
                try
                    result = load('AD.mat');
                    voltage = result.adValueTotal(adNum+1);
                    return
                catch
                    pause(0.01);
                end
            end
            voltage = 0;
        end
        
        function [obj] = adStream(obj,adNum)
            obj.client.send(['[{"ad',num2str(adNum),'": {"stream": true}}]'])
        end
        
        function [obj] = deinitAd(obj,adNum)
            obj.client.send(['[{"ad',num2str(adNum),'": null}]']);
            try
                delete('AD.mat');
            catch
            end
        end
        
        function [obj] = gpioOutput(obj,outputPin,output)
            if(output)
                obj.client.send(['[{"io',num2str(outputPin),'": true}]']);
            else
                obj.client.send(['[{"io',num2str(outputPin),'": false}]']);
            end
        end
        
        function obj = close(obj)
            obj.client.close
            obj.client.delete
        end
    end
end