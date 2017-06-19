
classdef Antenna
    properties
        Type
        Excitation
        Position
        Rotation
        Dimensions
        E
        Tag
        CurrentRotation
        Version
        Compare
        E_nonrot
    end
    methods
        function obj = set.Type(obj, String)
            %if ischar(String) && ndims(String) == 1
            possType = {'Isotropic','Dipole','Monopole','Import...','Imported','Misc'};
            switch String
                %case 'Import...'
                    %obj.Type = 'Imported';
                case possType
                    obj.Type = String;
                otherwise
                    error('Element type is not a string value');
            end
        end
        
        function obj = set.Position(obj, Value)
            if isnumeric(Value) && size(Value,1) == 1 && size(Value,2)==3
                obj.Position = Value;
            else
                error('Invalid position');
            end
        end
%         function obj = set.E(obj, Field)
%             if isstruct(Field)
%                 s = fieldnames(Field);
%                 switch s{1}
%                     case 'Theta'
%                         obj.E.Theta = Field.Theta;
%                         disp('Theta');
%                     case 'Phi'
%                         obj.E.Phi   = Field.Phi;
%                         disp('Phi');
%                     otherwise
%                         error('Fields must be Theta or Phi');
%                 end
%             else
%                 error('Fields must be E.Theta or E.Phi');
%             end
%             
%         end
    end
end