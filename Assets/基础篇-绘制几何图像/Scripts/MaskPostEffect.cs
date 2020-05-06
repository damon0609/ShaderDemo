using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaskPostEffect : MonoBehaviour {
    public Shader shader;


    [SerializeField]
    private Material material;

    public float maskSize;

    [Range(0,0.1f)]
    public float maskFacotr;
    private Vector2 pos = new Vector2(0.5f,0.5f);

    void Start () {
    }

    void Update () {
        if (Input.GetMouseButtonDown (0)) {
            Vector2 temp = Input.mousePosition;
            pos.x =temp.x / Screen.width;
            pos.y = temp.y / Screen.height;
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