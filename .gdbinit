source ~/lib/peda/peda.py
set disassembly-flavor intel

define nix
    ni
    x/4xw $rsp
end

# brew message:
# On 10.12 (Sierra) or later with SIP, you need to run this:
#  echo "set startup-with-shell off" >> ~/.gdbinit
set startup-with-shell off
