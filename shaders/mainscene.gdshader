shader_type canvas_item;

// Ширина и высота карты в пикселях
uniform float map_width = 512.0;
uniform float map_height = 512.0;

// Сила наклона
uniform float tilt_amount = 0.5; // 0..1

void vertex() {
    vec2 v = VERTEX;

    // Нормализованная вертикальная координата (0 = низ, 1 = верх)
    float t = v.y / map_height;
    t = clamp(t, 0.0, 1.0);

    // Смещение X: верх сжимается, низ остаётся
    float center_x = map_width / 2.0;
    v.x = center_x + (v.x - center_x) * (1.0 - t * tilt_amount);

    // Смещение Y: верх немного подтягивается
    v.y = v.y - t * tilt_amount * map_height * 0.3;

    VERTEX = v;
}

void fragment() {
    COLOR = texture(TEXTURE, UV) * COLOR;
}
