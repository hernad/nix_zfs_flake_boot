{
    networking = {  
        useDHCP = true;
        bridges = {
          "br0" = {
            interfaces = [ "wlo1" ];
          };
        };  
        #interfaces.br0.ipv4.addresses = [ 
        #    {
        #       address = "10.10.10.10";
        #       prefixLength = 24;
        #    }     
        # ];
        #defaultGateway = "10.10.10.1";
        #nameservers = ["10.10.10.1" "8.8.8.8"]; 


        #networkmanager.enable = true;
        #wireless.enable = false; # For Network Manager
        #firewall.enable = true;
        
        # For libvirt: https://releases.nixos.org/nix-dev/2016-January/019069.html
        firewall.checkReversePath = false;


    };
}
