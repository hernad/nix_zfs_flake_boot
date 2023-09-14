{ pkgs, ... }:

{

    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
    
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

        firewall.allowedTCPPorts = [ 8123 ];

        resolvconf.dnsExtensionMechanism = false;

        wireguard.interfaces = {
          wg0 = {
            # Determines the IP address and subnet of the client's end of the tunnel interface.
            ips = [ "192.168.245.11/24" ];
            #listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
            privateKeyFile = "/home/hernad/.wireguard/wg0.private.key";
            peers = [
          
               {
                  # Public key of the server (not a file path).
                  publicKey = "bMZFObF5tU94LqLKXhLsl+HOojtrCu6dAyc/sSTIxVk=";
                  # Forward all the traffic via VPN.
                  #allowedIPs = [ "0.0.0.0/0" ];
                  # Or forward only particular subnets
                  #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];
                  allowedIPs = [ "192.168.245.0/24" "192.168.168.0/24" "10.10.50.44/32" "192.168.90.0/24" ];
              
                  # Set this to the server IP and port.
                  endpoint = "wg.bring.out.ba:31194"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
          
                  # Send keepalives every 25 seconds. Important to keep NAT tables alive.
                  persistentKeepalive = 25;
              }
            ];
          
          };

          #wgcgnat = {
          #  ips = [ "10.100.0.2/24" ];
          #  privateKeyFile = "/home/hernad/.wireguard/wg0.private.key";
          #  # https://github.com/mochman/Bypass_CGNAT/blob/main/Wireguard%20Configs/Local%20Server/wg0.conf
          #  postSetup = ''
          #      ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dport 8123 -j DNAT --to-destination 192.168.168.150:8123
          #      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -p tcp --dport 8123 -j MASQUERADE
          #  '';
          #  postShutdown = ''
          #      ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -p tcp --dport 8123 -j DNAT --to-destination 192.168.168.150:8123
          #      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -p tcp --dport 8123 -j MASQUERADE
          #  '';
          #  allowedIPsAsRoutes = false;
          #  peers = [
          #     {
          #        publicKey = "sucaAlxoWAzJrzz7GTWv3niKqdeXOAPlNOJjh10883Q=";
          #        #allowedIPs = [ "0.0.0.0/0" ];
          #        allowedIPs = [ "10.100.0.1/32" ];
          #        # ora1
          #        endpoint = "193.123.37.206:55107";
          #        # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          #        persistentKeepalive = 25;
          #    }
          #  ];
          #};

          #wgcgnat2 = {
          #  ips = [ "10.101.0.2/24" ];
          #  privateKeyFile = "/home/hernad/.wireguard/wg0.private.key";
          #  # https://github.com/mochman/Bypass_CGNAT/blob/main/Wireguard%20Configs/Local%20Server/wg0.conf
          #  postSetup = ''
          #      ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dport 8123 -j DNAT --to-destination 192.168.168.150:8123
          #      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -p tcp --dport 8123 -j MASQUERADE
          #  '';
          #  postShutdown = ''
          #      ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -p tcp --dport 8123 -j DNAT --to-destination 192.168.168.150:8123
          #      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -p tcp --dport 8123 -j MASQUERADE
          #  '';
          #  allowedIPsAsRoutes = false;
          #  peers = [
          #     {
          #        publicKey = "sucaAlxoWAzJrzz7GTWv3niKqdeXOAPlNOJjh10883Q=";
          #        allowedIPs = [ "10.101.0.1/32" ];
          #        
          #        # ora2
          #        endpoint = "144.21.37.169:55107";
          #        # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          #        persistentKeepalive = 25;
          #    }
          #  ];
          #};


        };

        extraHosts =
        ''
        192.168.168.252 zimbra.bring.out.ba redmine.bring.out.ba keycloak.bring.out.ba
        '';

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
