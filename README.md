# OV7670 camera to ST7735 display on Basys 3 (VHDL)

Live video from an OV7670 camera module shown on an ST7735 SPI TFT using a
Digilent Basys 3 (Artix-7 XC7A35T). Pure VHDL, no IP cores.

- Camera: QVGA RGB565, down-scaled to 160x120 in the FPGA
- Frame buffer: 160x120x16 bit in Block RAM
- Display: ST7735, landscape, ~12.5 MHz SPI, continuous refresh
- Live colour tuning with the board buttons and switches

## Block diagram

```
OV7670 --> cam_capture --> frame_buffer --> st7735_ctrl --> ST7735
   ^                                            (spi_tx)
   +-- sccb_ov7670 <-- cam_tuner (buttons/switches)
```

## Files

| File | Purpose |
|---|---|
| `src/top_cam_lcd.vhd` | Top level |
| `src/cam_capture.vhd` | Samples OV7670 data (PCLK oversampled, single clock domain) |
| `src/frame_buffer.vhd` | Inferred Block RAM |
| `src/st7735_ctrl.vhd` | ST7735 init sequence and frame streaming |
| `src/spi_tx.vhd` | SPI byte transmitter |
| `src/sccb_ov7670.vhd` | SCCB master with OV7670 register table |
| `src/cam_tuner.vhd` | Runtime red/blue gain and white-balance control |
| `constraints/basys3.xdc` | Pin constraints |
| `create_project.tcl` | Recreates the Vivado project |

## Build

1. Open Vivado and run `Tools > Run Tcl Script...` with `create_project.tcl`
   (or create a project for part `xc7a35tcpg236-1` and add `src/*.vhd` and `constraints/basys3.xdc`).
2. Set `top_cam_lcd` as top.
3. Run Synthesis, Implementation, Generate Bitstream, then Program Device.

## Wiring (3.3 V)

| OV7670 | Basys 3 | ST7735 | Basys 3 |
|---|---|---|---|
| D0-D3 | JB1-JB4 | SCK | JC1 |
| D4-D7 | JB7-JB10 | SDA | JC2 |
| PCLK | JA1 | A0 (DC) | JC3 |
| VSYNC | JA2 | RESET | JC4 |
| HREF | JA3 | CS | JC7 |
| XCLK | JA4 | LED (BL) | JC8 |
| SIOC | JA7 | GND / VCC | Pmod GND / 3V3 |
| SIOD | JA8 | | |
| RESET | JA9 | | |
| PWDN | JA10 | | |

Add 4.7 kOhm pull-ups to 3V3 on SIOC and SIOD if your camera module has none.

## Controls

| Control | Function |
|---|---|
| btnC | Reset |
| btnU / btnD | Blue gain + / - |
| btnR / btnL | Red gain + / - |
| SW2 | Manual white balance (buttons work only when up) |
| SW1 | Swap red and blue |
| SW0 | Invert colours |
| LED0 | Blinks with camera frames |
| LED1 | Camera configured |

## Troubleshooting

- Set `COLOR_BAR => true` in `top_cam_lcd.vhd` to test the display path with the camera's colour bars.
- Image mirrored or upside-down: change `MVFP` (`x"1E00"` to `x"1E30"`) in `sccb_ov7670.vhd`, or the MX/MY bits of `MADCTL`.
- Shifted edge on the display: set `X_OFF` / `Y_OFF` to 1 or 2.
- Display glitches: raise `SCK_HALF` (4 to 6) in `top_cam_lcd.vhd`.

## Status

Written for Basys 3; adjust the pin constraints for other boards.


<img width="2890" height="2575" alt="IMG_20261111_024012" src="https://github.com/user-attachments/assets/9453a625-f26b-4861-80a6-86d668b15ee2" />
