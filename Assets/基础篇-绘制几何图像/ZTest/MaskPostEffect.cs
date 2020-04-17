using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaskPostEffect : MonoBehaviour {
    public Shader shader;

    private Vector2 pos = Vector2.zero;

    [SerializeField]
    private Material material;

    public float maskSize;

    [Range(0,0.1f)]
    public float maskFacotr;

    void Start () {
    }

    void Update () {
        if (Input.GetMouseButtonDown (0)) {
            Vector2 temp = Input.mousePosition;
            pos = new Vector2 (temp.x / Screen.width, temp.y / Screen.height);
        }
        if (material != null) {
            material.SetVector ("_Pos", pos);
            material.SetFloat ("_MaskSize", maskSize);
            material.SetFloat ("_MaskFactor", maskFacotr);
        }
    }

    private void OnRenderImage (RenderTexture src, RenderTexture dest) {
        if (material != null)
            Graphics.Blit (src, dest, material);
        else
            Graphics.Blit (src, dest);
    }
}