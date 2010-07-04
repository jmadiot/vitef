open Graphics

let sqr x = x *. x
let norm2 x y = sqr x +. sqr y
let norm x y = sqrt (norm2 x y)

let relief t (x : int) (y : int) : float =
  let x, y = float x, float y in
  0.5 *. (cos (-. 2. *. t +. 0.06 *. norm (x -. 300.) (y -. 200.)))

let huu (c : float) : color =
  let i = truncate (c *. 255.) in
  rgb i i i

let pattern (x : int) (y : int) : color =
  let w, h = 80, 70 in
  let fx, fy = float (x mod w) /. float w, float (y mod h) /. float h in
  let fx, fy = fx -. 0.5, fy -. 0.5 in
  huu (0.5 +. 0.5 *. cos (30. *. norm fx fy))

let widthdist d = abs_float (150. *. (atan (d /. 100.)) /. (atan 1.) /. 2.)
let widthdist d = 70. +.10. *. d

let modified (relief : int -> int -> float) w h =
  let modi = Array.init h (fun y -> Array.init w (fun x -> x)) in
  for y = 0 to h-1 do
    for x = 0 to w-1 do
      let x' = x - truncate (widthdist (relief x y)) in
      if x' >= 0 then
        modi.(y).(x) <- modi.(y).(x')
    done
  done;
  fun x y -> modi.(y).(x)

let build_image w h img pattern =
  let modi = modified img w h in
  let caa = Array.init h (fun y -> Array.init w (fun x ->
    pattern (modi x y) y))
  in
  make_image caa

open Format

let main =
  let () = open_graph " 600x400" in
  let w, h = 600, 400 in
    let t = Sys.time () in
    let i = build_image w h (relief t) pattern in
    draw_image i 0 0;
  let _ = wait_next_event [Key_pressed] in
  while true do
    let t = Sys.time () in
    let i = build_image w h (relief t) pattern in
    draw_image i 0 0;
  done;
  let _ = wait_next_event [] in
  ()

