# mbrow.sh
Minimal browser written in pure bash

## Usage
```
sudo apt install python3-html2text wget cargo tmux git
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cargo install viu
git clone https://github.com/mickenordin/mbrow.sh/
cd mbrow.sh
sudo cp mbrow.desktop /usr/share/applications/
sudo cp tmux.conf /usr/local/etc/mbrow-tmux.conf
sudo cp mbrow mbrow.sh /usr/local/bin
sudo update-mime
mbrow <url>
```
