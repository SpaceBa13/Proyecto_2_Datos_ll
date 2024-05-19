#include "Backtracking.h"
#include <Godot.hpp>
#include <Vector2.hpp>
#include <Array.hpp>
#include "utility_functions.hpp"
#include "Node2D.hpp"

using namespace godot;

void Backtracking::_register_methods() {
    register_method("_init", &Backtracking::_init);
    register_method("make_backtrack_path", &Backtracking::make_backtrack_path);
    register_method("is_valid_move", &Backtracking::is_valid_move);
    register_method("get_backtrack_path_aux", &Backtracking::get_backtrack_path_aux);
}

void Backtracking::_init() {
    tile_map = nullptr;
}

Array Backtracking::make_backtrack_path(Vector2 start, Vector2 goal) {
    Array path;
    Array current_path;
    get_backtrack_path_aux(start, goal, current_path, path);
    return path;
}

bool Backtracking::is_valid_move(Vector2 neighbor) {
    Ref<TileSet> tileset = tile_map->get_tileset();
    int tile_id = tile_map->get_cell(neighbor);
    if (tile_id == -1 || !tileset->tile_get_custom_data(tile_id, "walkable")) {
        return false;
    }
    else {
        return true;
    }
}

bool Backtracking::get_backtrack_path_aux(Vector2 pos, Vector2 goal, Array current_path, Array& path) {
    if (pos == goal) {
        for (int i = 0; i < current_path.size(); ++i) {
            path.append(current_path[i]);
        }
        path.append(pos);
        return true;
    }

    if (is_valid_move(pos)) {
        current_path.append(pos);
        if (pos.x < goal.x && pos.y < goal.y) {
            if (get_backtrack_path_aux(pos + Vector2(1, 1), goal, current_path, path)) {
                return true;
            }
        }
        if (pos.x > goal.x && pos.y > goal.y) {
            if (get_backtrack_path_aux(pos + Vector2(-1, -1), goal, current_path, path)) {
                return true;
            }
        }
        if (pos.x > goal.x && pos.y < goal.y) {
            if (get_backtrack_path_aux(pos + Vector2(-1, 1), goal, current_path, path)) {
                return true;
            }
        }
        if (pos.x < goal.x && pos.y > goal.y) {
            if (get_backtrack_path_aux(pos + Vector2(1, -1), goal, current_path, path)) {
                return true;
            }
        }
        if (pos.x < goal.x) {
            if (get_backtrack_path_aux(pos + Vector2(1, 0), goal, current_path, path)) {
                return true;
            }
        }
        if (pos.x > goal.x) {
            if (get_backtrack_path_aux(pos + Vector2(-1, 0), goal, current_path, path)) {
                return true;
            }
        }
        if (pos.y > goal.y) {
            if (get_backtrack_path_aux(pos + Vector2(0, -1), goal, current_path, path)) {
                return true;
            }
        }
        if (pos.y < goal.y) {
            if (get_backtrack_path_aux(pos + Vector2(0, 1), goal, current_path, path)) {
                return true;
            }
        }

        current_path.pop_back();
    }

    return false;
}
