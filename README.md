![screenshot](screenshot.png)

# rofi-checklist

A minimalist checklist menu for [rofi](/davatorium/rofi).

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
and copy [rofi-checklist.sh](rofi-checklist.sh) to `/usr/bin/rofi-checklist`.

Alternatively you can curl/wget the file straight to `/usr/bin/rofi-checklist` and add the executable flag manually.

## Usage

Rofi-checklist is best when mapped to a keybinding. Simply create a keybind that calls `rofi-checklist`.

For example, in i3, you can map it `Alt`+`T` (**T** for **T**asks) by adding `bindsym Mod1+T exec rofi-checklist` to your `~/.config/i3/config` file.

Rofi-checklist is very simple to use. Once launched, it shows a list of tasks. If you press enter on an incomplete task, it is marked as complete. Selecting it again removes it from the list.

There are two actions at the top of the list, one for clearing all tasks and one for clearing only completed tasks. To add a new task, simply type a task name that doesn't exist yet and press enter.

Rofi-checklist stores the checklist in `~/.rofi-checklist` as a markdown-compliant format, such as the following:

```MD
- [x] Consume the blood of my enemies
- [x] Drink coffee
- [ ] Go to bed
```

This allows the checklist file to be used within other markdown editors. For example, you can make a symbolic link from `~/.rofi-checklist` to somewhere in your [Obsidian](https://obsidian.md/) vault - allowing a nice integration into your knowledge management software. If there's interest, support for configurable/multiple checklist file sources might be added in the future.
