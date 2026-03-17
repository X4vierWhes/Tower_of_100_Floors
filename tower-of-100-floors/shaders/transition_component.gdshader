shader_type canvas_item;

// Espaçamento entre os pontos (em pixels)
uniform float spacing = 25.0;

// Progresso da animação (de 0 a 1)
uniform float animation_progress : hint_range(0.0, 1.0) = 0.0;

// Tamanho relativo dos pontos (de 0 a 1)
uniform float dot_size : hint_range(0.0, 1.0) = 1.0;

// Cor dos pontos
uniform vec4 dot_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    // 1. Se o progresso da animação for 0, não desenha nada
    if (animation_progress <= 0.0) {
        discard; // Interrompe o desenho do fragmento
    }

    // 2. Calcula o tamanho da tela em pixels
    vec2 screen_size = vec2(1.0) / SCREEN_PIXEL_SIZE;

    // Determina quantas células de grade cabem na tela com base no espaçamento
    vec2 grid_count = floor(screen_size / spacing);

    // 3. Calcula a posição normalizada do fragmento na grade (valores entre 0 e 1)
    vec2 norm_pos = UV * screen_size / (grid_count * spacing);

    // 4. Define um "atraso" com base na posição (da diagonal superior esquerda para inferior direita)
    float delay = (norm_pos.x + norm_pos.y) * 0.5;

    // 5. Primeira filtragem: descarta fragmentos que ainda não atingiram o "limiar de visibilidade"
    float visible_threshold = delay * 0.1 + 0.01; // Quanto mais longe na diagonal, mais tempo demora para aparecer
    if (animation_progress < visible_threshold) {
        discard;
    }

    // 6. Calcula o quanto a transição foi feita com base no atraso
    float transition = 0.3;
    float scale = smoothstep(
        delay - transition,
        delay + transition,
        animation_progress * (1.0 + transition)
    );

    // Segunda filtragem: descarta fragmentos com escala muito pequena (evita resíduos visuais)
    if (scale < 0.005) {
        discard;
    }

    // 7. Calcula a posição do centro do ponto da grade mais próximo
    vec2 grid_center = (floor(UV * screen_size / spacing) + 0.5) * spacing;

    // Distância do fragmento até o centro do ponto
    float dist = length(UV * screen_size - grid_center);

    // Raio do ponto (ajustado pelo progresso da animação)
    float dot_radius = dot_size * scale * spacing * 0.8;

    // 8. Aplica uma suavização nas bordas do ponto
    float alpha = 1.0 - smoothstep(
        max(dot_radius - 1.5, 0.0),
        dot_radius + 1.5,
        dist
    );

    // Terceira filtragem: descarta fragmentos com alpha quase nulo
    if (alpha < 0.01) discard;

    // 9. Define a cor final do fragmento com transparência (alpha)
    COLOR = vec4(dot_color.rgb, alpha);
}