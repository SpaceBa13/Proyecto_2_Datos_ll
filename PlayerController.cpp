#include "PlayerController.h"
#include <Input.hpp>
#include "utility_functions.hpp"
#include "animation_player.hpp"
#include <sprite2d.hpp>

using namespace godot;

void PlayerController::_bind_methods() {
    ClassDB::bind_method(D_METHOD("_init"), &PlayerController::_init);
    ClassDB::bind_method(D_METHOD("validate_input"), &PlayerController::validate_input);
    ClassDB::bind_method(D_METHOD("animatedMovement"), &PlayerController::animatedMovement);
}

void PlayerController::_init() {}

void PlayerController::_ready() {
    // Inicialización de las variables
    animation = get_node<AnimationPlayer>("AnimationPlayer");
    sprite = get_node<Sprite2D>("Sprite2D");
}

void PlayerController::_process(float delta) {
    validate_input();
    animatedMovement();
    move_and_slide();
}

void PlayerController::validate_input() {
    Vector2 move_direction = Input::get_singleton()->get_vector("ui_left", "ui_right", "ui_up", "ui_down");
    Vector2 velocity = move_direction * speed;
    set_velocity(velocity);
}

void PlayerController::animatedMovement(){
    
    if (animation == nullptr) return;
    if (sprite == nullptr) return;
    
    if (get_velocity().length() == 0) {
        animation->stop();
    }
    
    else {
        String dire_anim = "Walk_down";
        sprite->set_flip_h(false);
        if (get_velocity().x < 0) {
            dire_anim = "Walk_right";
            sprite->set_flip_h(true);
        }
        else if (get_velocity().y > 0) {
            dire_anim = "Walk_right";
        }
        else if (get_velocity().x < 0) {
            dire_anim = "Walk_up";
        }
        animation->play(dire_anim);
    }
}

PlayerController::PlayerController() {}

PlayerController::~PlayerController() {}