tshark="/Applications/Wireshark.app/Contents/MacOS/tshark"
files=$(find *.pcap)

for file in $files
do
    
    found=$($tshark -r $file -T fields -e tcp.stream -Y 'http and http.request.uri contains "iter=2949"' 2>/dev/null)

    if [[ ! -z $found ]]
    then
        echo $file
        item=$(echo $found | awk '{print $1}')

        echo $found

        $tshark -r $file -Y "tcp.stream==${found}" #-z follow,tcp,raw,$item
    fi
done
