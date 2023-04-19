{

      
    networking = {  

        # https://hackmd.io/@scopatz/rJJGqLQYU
        # https://grahamc.com/blog/erase-your-darlings/
        # https://nixos.wiki/wiki/Wpa_supplicant

        
        #networkmanager.unmanaged = [ "interface-name:wl*" ];
        #useDHCP = true;

        # Error: Device does not allow enslaving to a bridge
        #bridges = {
        #  "br0" = {
        #    interfaces = [
        #      "enp5s0f4u2"
        #    ];
        #  };
        #};
        
        #interfaces.br0.ipv4.addresses = [ 
        #    {
        #       address = "192.168.169.100";
        #       prefixLength = 24;
        #    }     
        #];
        #defaultGateway = "192.168.169.251";
        #nameservers = [
        # "192.168.169.10"
        # "192.168.169.10"
        #]; 


        networkmanager.enable = true;
        #networkmanager.enable = false;
        
        #wireless.enable = true; 
        #firewall.enable = true;
        
        # For libvirt: https://releases.nixos.org/nix-dev/2016-January/019069.html
        firewall.checkReversePath = false;

        #wireless.networks."husremovic-r" = {
        #    hidden = true;
        #    auth = ''
        #    key_mgmt=WPA-EAP
        #    eap=PEAP
        #    phase2="auth=MSCHAPV2"
        #    identity="ernad.husremovic"
        #    password="xxxxxxxxxxxxxxxxxxxxxx"
        #    '';
        #};

    };
}
