Supported on UBUNTU & based distros.

Fire up terminal and just run the following:
    git clone https://github.com/nitinnarwal/wifi_script.git
    cd wifi_script
    chmod +x ni_three.sh
    sudo ./ni_three.sh
    
Voila!

Note: This script runs by sending deauthentication packets to the target router/hotspot to disconnect the clients connected to it and capturing the handshake when the client tries to reconnect. So, make sure atleast one client is connected to the target when you run the script.
This doesn't mean that the connected device should be yours. The client can be anyone but has to be atleast one.
