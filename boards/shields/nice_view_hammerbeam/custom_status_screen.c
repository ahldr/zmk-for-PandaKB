/*
 * Copyright (c) 2023 The ZMK Contributors
 * SPDX-License-Identifier: MIT
 */

#include <zephyr/logging/log.h>
LOG_MODULE_DECLARE(zmk, CONFIG_ZMK_LOG_LEVEL);

#if !IS_ENABLED(CONFIG_ZMK_SPLIT) || IS_ENABLED(CONFIG_ZMK_SPLIT_ROLE_CENTRAL)
#include "widgets/status.h"
#include "widgets/bongo_cat.h"

static struct zmk_widget_status status_widget;
static struct zmk_widget_wpm_bongo_cat bongo_cat_widget;

lv_obj_t *zmk_display_status_screen() {
    lv_obj_t *screen = lv_obj_create(NULL);

    zmk_widget_status_init(&status_widget, screen);
    lv_obj_align(zmk_widget_status_obj(&status_widget), LV_ALIGN_TOP_LEFT, 0, 0);

    zmk_widget_wpm_bongo_cat_init(&bongo_cat_widget, screen);
    // Center bongo cat in the 140x68 area (cat is 26x50)
    lv_obj_align(zmk_widget_wpm_bongo_cat_obj(&bongo_cat_widget), LV_ALIGN_TOP_LEFT, 57, 9);

    return screen;
}
#else
#include "widgets/peripheral_status.h"

static struct zmk_widget_status status_widget;

lv_obj_t *zmk_display_status_screen() {
    lv_obj_t *screen = lv_obj_create(NULL);

    zmk_widget_status_init(&status_widget, screen);
    lv_obj_align(zmk_widget_status_obj(&status_widget), LV_ALIGN_TOP_LEFT, 0, 0);

    return screen;
}
#endif
