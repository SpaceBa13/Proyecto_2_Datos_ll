#ifndef PLAYER_CONTROLLER_H
#define PLAYER_CONTROLLER_H

#include <Godot.hpp>
#include <character_body2d.hpp>
#include "ref.hpp"

namespace godot {

    class PlayerController : public CharacterBody2D {
        GDCLASS(PlayerController, CharacterBody2D)

    protected:
        static void _bind_methods();

    private:
        int speed = 100;
        class AnimationPlayer* animation{ nullptr };
        class Sprite2D* sprite{ nullptr };


    public:
        void _init();
        void _ready();
        void _process(float delta);

        PlayerController();
        ~PlayerController();

        void validate_input();

        void animatedMovement();

    };

}

#endif // PLAYER_CONTROLLER_H