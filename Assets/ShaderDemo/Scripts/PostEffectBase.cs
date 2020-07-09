using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class PostEffectBase : MonoBehaviour {

    public Shader zoomShader;

    Material material;
    private Vector2 pos = new Vector4 (0.0f, 0.0f);
    private Vector2 target;

    private Vector2 dir;

    [SerializeField]
    [Range (0, 1)]
    private float mScaleFactor;

    [SerializeField]
    [Range (0, 1)]
    private float mScaleArea;

    [SerializeField]
    [Range (0, 1)]
    private float mEdgeSize;
    private float scaleValue;

    private Material CheckShaderAndMaterial (Shader shader) {
        Material mat = null;
        if (shader == null || !shader.isSupported)
            mat = null;
        else {
            mat = new Material (shader);
            mat.hideFlags = HideFlags.DontSave;
        }
        return mat;
    }

    void Start () {
        material = CheckShaderAndMaterial (zoomShader);
        if (material != null) {
            material.SetFloat ("_ScaleFactor", mScaleFactor);
            material.SetFloat ("_Radius", mScaleArea);
            material.SetFloat ("_EdgeSize", mEdgeSize);
        }
        target = new Vector2 (Screen.width / 2, Screen.height / 2);
        dir = target - pos;
    }

    void Update () {
        if (Vector2.Distance (target, pos) <= 5f) {
            float xPos = UnityEngine.Random.Range (0, Screen.width);
            float yPos = UnityEngine.Random.Range (0, Screen.height);
            target = new Vector2 (xPos, yPos);
            dir = target - pos;
        }
        pos += dir.normalized * Time.deltaTime * 300;

        scaleValue += Input.GetAxis ("Mouse ScrollWheel");
        scaleValue = Mathf.Clamp (scaleValue, -1, 1);
    }

    private void OnRenderImage (RenderTexture src, RenderTexture dest) {
        if (material != null) {
            Vector2 temp = new Vector2 (pos.x / Screen.width, pos.y / Screen.height);
            material.SetVector ("_Pos", temp);
            material.SetFloat ("_ScaleFactor", mScaleFactor + scaleValue);
            material.SetFloat ("_Radius", mScaleArea);
            material.SetFloat ("_EdgeSize", mEdgeSize);
            Graphics.Blit (src, dest, material);
        } else
            Graphics.Blit (src, dest);
    }
    private void OnDestroy () {
        if (material != null) {
            material.SetFloat ("_Radius", 0);
            material.SetFloat ("_ScaleFactor", 0);
            material.SetFloat ("_Radius", 0);
            material.SetFloat ("_EdgeSize", 0);
            pos = new Vector4 (0f, 0f);
        }
    }
}