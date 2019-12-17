classdef SimpleClient2 < WebSocketClient
    %CLIENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = SimpleClient2(varargin)
            %Constructor
            obj@WebSocketClient(varargin{:});
        end
    end
    
    methods (Access = protected)
        function onOpen(obj,message)
            % This function simply displays the message received
            fprintf('%s\n',message);
        end
        
        function onTextMessage(obj,message)
            
            if(exist('FLAGRUN','file')==2)
               return; 
            else
               touch('FLAGRUN'); 
            end
            
            % This function simply displays the message received
            value = jsondecode(message);
            if(~iscell(value))
                value = {value};
            end
            
            if(exist('AD.mat','file')~=2)
                adValueTotal = zeros(12,1);
            else
                result = load('AD.mat'); 
                adValueTotal = result.adValueTotal;
            end
            if(exist('IO.mat','file')~=2)
                ioValueTotal = zeros(12,1);
            else
                result = load('IO.mat'); 
                ioValueTotal = result.ioValueTotal;
            end
            
            checkCONfunc = @(x) ~isempty(regexp(x,'\[{"ws":{"redirect":"wss://[0-9]{1,2}ws.obniz.io"}}\]', 'once'));
            if(checkCONfunc(message))
                save('tempReturn.mat','message');
                fprintf('Message received:\n%s\n',message);
                delete('FLAGRUN');
                return;
            end
            
            for i= 1:1:length(value)

                fn = fieldnames(value{i});
                
                if(~cellfun(@isempty,regexp(fn,'ad[0-9]{1,2}')))
                    
                    pickADfunc = @(x) value{i}.(x);
                    adValue = cellfun(pickADfunc, fn);
                    
                    posADfunc = @(x) sscanf(x,'ad%d');
                    adPosNum = cellfun(posADfunc,fn);
                    
                    adValueTotal(adPosNum+1) = adValue;
                    
                end
                if(~cellfun(@isempty,regexp(fn,'ad[0-9]{1,2}')))
                    pos = ~cellfun(@isempty,regexp(fn,'io[0-9]{1,2}'));
                    iofn = fn(pos);
                    pickIOfunc = @(x) value{i}.(x);
                    ioValue = cellfun(pickIOfunc, iofn);
                    
                    posIOfunc = @(x) sscanf(x,'io%d');
                    ioPosNum = cellfun(posIOfunc,iofn);
                    
                    ioValueTotal(ioPosNum+1) = ioValue;
                end
                
            end
            
            save('AD.mat','adValueTotal');
            save('IO.mat','ioValueTotal');
            
            delete('FLAGRUN');
        end
        
        function onBinaryMessage(obj,bytearray)
            % This function simply displays the message received
            fprintf('Binary message received:\n');
            fprintf('Array length: %d\n',length(bytearray));
        end
        
        function onError(obj,message)
            % This function simply displays the message received
            fprintf('Error: %s\n',message);
        end
        
        function onClose(obj,message)
            % This function simply displays the message received
            fprintf('%s\n',message);
        end
    end
end

