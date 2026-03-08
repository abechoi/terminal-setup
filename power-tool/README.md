# power

Mac power management for overnight trading sessions. Prevents macOS from sleeping, hibernating, or locking the screen while IB Gateway needs to stay connected.

## Quick Install (fresh Mac)

```bash
./install.sh
```

That's it. Copies `power` to `~/bin/`, ensures it's on your PATH, and makes it executable.

## Commands

```
power help          Show this info
power status        What profile is active right now

sudo power default      Normal Mac. Sleeps, dims, hibernates.
sudo power moderate     No sleep. Display dims after 30 min.
sudo power aggressive   No sleep + caffeinate. Use before bed.
sudo power nuclear      Aggressive + screen lock off.
```

## Profiles

| Profile    | Sleep | Display | Caffeinate | Screen Lock | Use Case                  |
|------------|-------|---------|------------|-------------|---------------------------|
| default    | on    | 10 min  | no         | normal      | Daily use, not trading    |
| moderate   | off   | 30 min  | no         | normal      | Daytime sessions          |
| aggressive | off   | off     | YES (24/7) | normal      | **Overnight IB Gateway**  |
| nuclear    | off   | off     | YES (24/7) | OFF         | If aggressive still fails |

## Why caffeinate matters

`pmset sleep 0` is not enough on Apple Silicon Macs. macOS has a separate "SleepServices" daemon that can trigger idle sleep even when pmset says never sleep. The `aggressive` and `nuclear` profiles install a persistent `caffeinate -dims` LaunchAgent that creates a system-level sleep assertion macOS cannot override. It auto-restarts if killed and survives reboots.

## Typical workflow

```bash
# Before bed (trading overnight)
sudo power aggressive

# Next morning
sudo power moderate

# Not trading at all
sudo power default
```
