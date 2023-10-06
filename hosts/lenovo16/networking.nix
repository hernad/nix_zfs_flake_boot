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
            ips = [ "192.168.245.199/32" ];
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

                  # https://www.procustodibus.com/blog/2021/03/wireguard-allowedips-calculator/

                  # allowedIps: 192.168.245.0/24, 192.168.168.0/24, 10.10.50.44/32, 192.168.90.0/24
                  # disallowdIps: 192.168.168.251

                  # kada se nalazim u officesa mrezi, wg server je lan host
                  #❯ traceroute 192.168.168.251
                  #traceroute to 192.168.168.251 (192.168.168.251), 30 hops max, 60 byte packets
                  # 1  _gateway (192.168.168.251)  1.006 ms  1.157 ms  1.329 ms
                  #
                  #❯ traceroute 192.168.168.252
                  #traceroute to 192.168.168.252 (192.168.168.252), 30 hops max, 60 byte packets
                  # 1  192.168.245.1 (192.168.245.1)  8.596 ms  8.556 ms  8.581 ms
                  # 2  192.168.168.252 (192.168.168.252)  8.564 ms  8.549 ms  8.535 ms

                  allowedIPs = [ 
                    "10.10.50.44/32" 
                    "192.168.90.0/24" 
                    "192.168.168.0/25" 
                    "192.168.168.128/26" 
                    "192.168.168.192/27" 
                    "192.168.168.224/28" 
                    "192.168.168.240/29" 
                    "192.168.168.248/31" 
                    "192.168.168.250/32" 
                    "192.168.168.252/30"
                    "192.168.245.0/24" ];
              
                  # Set this to the server IP and port.
                  endpoint = "192.168.168.251:31194"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
          

          
                  # Send keepalives every 25 seconds. Important to keep NAT tables alive.
                  persistentKeepalive = 25;
              }
            ];
          
          };


        wgrg = {
            # Determines the IP address and subnet of the client's end of the tunnel interface.
            ips = [ "192.168.200.16/32" ];
            #listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
            privateKeyFile = "/home/hernad/.wireguard/wgrg.private.key";
            peers = [
          
               {
                  publicKey = "U/sx63bm1GixUzRY7sja5Zga4ugGLmXQFQGxgjtQwxo=";
                
                  allowedIPs = [ 
                    "192.168.200.0/24" 
                    "192.168.56.0/23" 
                    "192.168.23.0/24" 
                  ];
              
                  # Set this to the server IP and port.
                  endpoint = "wg.rama-glas.com:31194"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
          
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
        #192.168.168.252 zimbra.bring.out.ba redmine.bring.out.ba keycloak.bring.out.ba
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
