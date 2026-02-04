Recommended workflow after repo is cloned
# On Ubuntu VM (VirtualBox)
sudo ./install.sh

# After initial setup
sudo ./scripts/50-live-update.sh ark
sudo ./scripts/50-live-update.sh palworld

# When migrating to Proxmox
cd scripts/proxmox
./00-detect-host-cpu.sh
./10-calc-core-groups.sh
./20-pin-vm.sh
./30-isolate-host.sh
./40-detect-gpu.sh
./41-bind-gpu.sh <GPU_PCI> <AUDIO_PCI>
./42-assign-gpu-vm.sh