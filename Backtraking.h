#ifndef BACKTRACKING_H
#define BACKTRACKING_H

#include <Godot.hpp>
#include <Vector2.hpp>
#include <Array.hpp>
#include "utility_functions.hpp"
#include "Node2D.hpp"

namespace godot {

    class Backtracking : public Node2D {
        GDCLASS(Backtracking, Node2D)

    private:
        TileMap* tile_map;

    public:
        static void _register_methods();
        void _init();

        Array make_backtrack_path(Vector2 start, Vector2 goal);
        bool is_valid_move(Vector2 neighbor);
        bool get_backtrack_path_aux(Vector2 pos, Vector2 goal, Array current_path, Array& path);
    };

}

#endif // BACKTRACKING_H
