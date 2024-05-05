---@diagnostic disable:undefined-global

------ DEFINTIONS FOR FILE ------
----
-- CGLM_BUILD_DIR - overrides cglm's build directory.
-- CGLM_OBJ_DIR   - overrides cglm's intermediate build directory.
----
---------------------------------

cglm_version = '0.9.4'

newoption {
  trigger='cglm-static',
  description='Builds cglm as a static library.'
}

project 'cglm'
  language 'c'
  cdialect 'c11'
  
  filter 'options:cglm-static'
    kind 'staticlib'
    defines {
      'CGLM_STATIC'
    }
  filter 'not options:cglm-static'
    kind 'sharedlib'
    defines {
      'CGLM_EXPORTS'
    }
  filter '*'

  targetname ('cglm-'..cglm_version)
  targetdir (CGLM_BUILD_DIR or 'build/%{prj.config}/bin')
  objdir (CGLM_OBJ_DIR or 'build/')

  files {
    'include/cglm/**',

    'src/euler.c',
    'src/affine.c',
    'src/io.c',
    'src/quat.c',
    'src/cam.c',
    'src/vec2.c',
    'src/ivec2.c',
    'src/vec3.c',
    'src/ivec3.c',
    'src/vec4.c',
    'src/ivec4.c',
    'src/mat2.c',
    'src/mat2x3.c',
    'src/mat2x4.c',
    'src/mat3.c',
    'src/mat3x2.c',
    'src/mat3x4.c',
    'src/mat4.c',
    'src/mat4x2.c',
    'src/mat4x3.c',
    'src/plane.c',
    'src/frustum.c',
    'src/box.c',
    'src/project.c',
    'src/sphere.c',
    'src/ease.c',
    'src/curve.c',
    'src/bezier.c',
    'src/ray.c',
    'src/affine2d.c',
    'src/clipspace/ortho_lh_no.c',
    'src/clipspace/ortho_lh_zo.c',
    'src/clipspace/ortho_rh_no.c',
    'src/clipspace/ortho_rh_zo.c',
    'src/clipspace/persp_lh_no.c',
    'src/clipspace/persp_lh_zo.c',
    'src/clipspace/persp_rh_no.c',
    'src/clipspace/persp_rh_zo.c',
    'src/clipspace/view_lh_no.c',
    'src/clipspace/view_lh_zo.c',
    'src/clipspace/view_rh_no.c',
    'src/clipspace/view_rh_zo.c',
    'src/clipspace/project_no.c',
    'src/clipspace/project_zo.c'
  }
