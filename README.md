![screenshot](screenshot.png)

# rofi-checklist

A minimalist checklist menu for [rofi](/davatorium/rofi) (and also [dmenu](https://tools.suckless.org/dmenu/)).

## Installation

Make sure you have [Nerd Fonts](https://www.nerdfonts.com/) installed for the icons to work.

### Arch Linux

rofi-checklist is available on the AUR, [rofi-checklist-git](https://aur.archlinux.org/packages/rofi-checklist-git). 

If you have the AUR helper [yay](/Jguer/yay) installed, you can easily install rofi-checklist on your system using the following command:

```SH
yay -S rofi-checklist-git
```

[rofi](/davatorium/rofi) is a prequisite, and will be installed if it is not already.

This is my first package on the AUR, so my apologies if I've made any mistakes packaging it!

### Other Linux distros

Ensure rofi is installed, then clone this repository,
```SH
git clone https://github.com/ElnuDev/rofi-checklist.git
```
and copy [rofi-checklist.sh](rofi-checklist.sh) to `/usr/local/bin/rofi-checklist`.

Alternatively you can curl/wget the file straight to `/usr/local/bin/rofi-checklist` and add the executable flag manually.

## Usage

- `rofi-checklist`: Run rofi-checklist in automatic menu mode. Will use either rofi or dmenu depending on which is installed, preferring rofi.
- `rofi-checklist rofi`: Run rofi-checklist in rofi mode. Will use rofi, and error even if dmenu is installed.
- `rofi-checklist dmenu`: Run rofi-checklist in dmenu mode. Will use dmenu, and error even if rofi is installed.

rofi-checklist is best when mapped to a keybinding. Simply create a keybind that calls `rofi-checklist`.

For example, in i3, you can map it `Alt`+`T` (**T** for **T**asks) by adding `bindsym Mod1+T exec rofi-checklist` to your `~/.config/i3/config` file.

rofi-checklist is very simple to use. Once launched, it shows a list of tasks. If you press enter on an incomplete task, it is marked as complete. Selecting it again removes it from the list.

There are two actions at the top of the list, one for clearing all tasks and one for clearing only completed tasks. To add a new task, simply type a task name that doesn't exist yet and press enter.

rofi-checklist stores the checklist in `~/.rofi-checklist` as a markdown-compliant format, such as the following:

```MD
- [x] Consume the blood of my enemies
- [x] Drink coffee
- [ ] Go to bed
```

This allows the checklist file to be used within other markdown editors. For example, you can make a symbolic link from `~/.rofi-checklist` to somewhere in your [Obsidian](https://obsidian.md/) vault — allowing a nice integration into your knowledge management software.

## Configuration

To configure rofi-checklist, create `~/.config/rofi-checklist.conf`. For example, the following changes the checklist file path and makes the checkboxes square instead of circular:

```SH
FILE=~/.rofi-checklist2
EMPTY=
FILLED=
```

Ability to switch between checklist files within rofi-checklist itself will be coming soon.
