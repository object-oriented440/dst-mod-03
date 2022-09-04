---
--- @author zsh in 2022/8/27 16:09
---


local envAPI = require('chang_m3.dst.env.env_apis');

envAPI.reskin('backpack', 'swap_backpack', { 'dst_m3_backpack' });
envAPI.reskin('krampus_sack', 'swap_krampus_sack', { 'dst_m3_krampus_sack' });
envAPI.reskin('piggyback', 'swap_piggyback', { 'dst_m3_piggyback' });
envAPI.reskin('seedpouch', 'seedpouch', { 'dst_m3_seedpouch' });

envAPI.reskin('cane', 'swap_cane', { 'dst_m3_cane' });

envAPI.reskin('treasurechest', 'treasure_chest', { 'dst_m3_small_container_item', 'dst_m3_small_container_chest' });
envAPI.reskin('dragonflychest', 'dragonfly_chest', { 'dst_m3_big_container_item', 'dst_m3_big_container_chest' });