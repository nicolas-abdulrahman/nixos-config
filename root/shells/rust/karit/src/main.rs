use evdev::{Device, InputEventKind, Key};
use std::fs::File;
use std::os::unix::io::AsRawFd;
use std::thread;
use std::time::Duration;
use uinput::event::keyboard::Key as UKey;
use uinput::event::keyboard::Keyboard;

fn main() -> anyhow::Result<()> {
    // Open the physical keyboard device (adjust path to your keyboard device)
    aa
    let mut device = Device::open("/dev/input/event17")?;

    println!("Remapping WASD → Arrow keys");
    // Create a virtual keyboard device
    let mut uinput_dev = uinput::default()?
        .name("rust-remapper")?
        .event(Keyboard::All)?
        .create()?;

    loop {
        for ev in device.fetch_events()? {
            if let InputEventKind::Key(key) = ev.kind() {
                // Only handle key press/release events
                if ev.value() == 1 || ev.value() == 0 {
                    // Map WASD to arrow keys
                    let remapped = match key {
                        Key::KEY_W => Some(UKey::Up),
                        Key::KEY_A => Some(UKey::Left),
                        Key::KEY_S => Some(UKey::Down),
                        Key::KEY_D => Some(UKey::Right),
                        other => Some(UKey::new(other.0)), // Pass other keys unchanged
                    };

                    if let Some(uinput_key) = remapped {
                        // Send event to virtual keyboard
                        uinput_dev.write(
                            uinput::event::keyboard::Keyboard::Key(uinput_key),
                            ev.value(),
                        )?;
                        uinput_dev.synchronize()?;
                    }
                }
            }
        }
        // Sleep a little to avoid busy looping
        thread::sleep(Duration::from_millis(5));
    }
}
