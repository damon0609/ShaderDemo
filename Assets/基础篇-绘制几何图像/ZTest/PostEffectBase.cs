using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostEffectBase : MonoBehaviour {
    [SerializeField]
    Material material;
    void Start () {

    }

    void Update () {
        if (Input.GetMouseButtonDown (0)) {
            Vector2 pos = Input.mousePosition;
            float x = pos.x / Screen.width;
            float y = pos.y / Screen.height;

            material.SetVector ("_pos", new Vector4 (x, y));
            Debug.Log ("--" + x + "--" + y);
        }
    }

    private void OnRenderImage (RenderTexture src, RenderTexture dest) {
        if (material != null) {
            Graphics.Blit (src, dest, material);
        }
    }
}