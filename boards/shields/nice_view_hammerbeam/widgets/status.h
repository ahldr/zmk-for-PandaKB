/*
 * Copyright (c) 2023 The ZMK Contributors
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <zephyr/sys/slist.h>
#include <lvgl.h>
#include "util.h"

struct zmk_widget_status {
    sys_snode_t node;
    lv_obj_t *obj;
    lv_obj_t *profile_canvas;
    lv_color_t cbuf[CANVAS_SIZE * CANVAS_SIZE];
    lv_color_t profile_cbuf[3 * 31];
    struct status_state state;
};

int zmk_widget_status_init(struct zmk_widget_status *widget, lv_obj_t *parent);
lv_obj_t *zmk_widget_status_obj(struct zmk_widget_status *widget);
