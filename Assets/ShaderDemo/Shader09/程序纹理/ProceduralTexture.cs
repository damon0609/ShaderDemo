using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif
public class ProceduralTexture : MonoBehaviour
{
    public Material material;
    public Texture2D generateTex;

    [SerializeField]
    private float s_Radius = 1.0f;
    public float radius
    {
        get { return s_Radius; }
        set { s_Radius = value; UpdateMaterial(); }
    }

    [SerializeField]
    private float s_Interval = 0.0f;
    public float interval
    {
        get { return s_Interval; }
        set
        {
            s_Interval = value;
            UpdateMaterial();
        }
    }

    [SerializeField]
    private int s_TextureWidth = 512;
    public int width
    {
        get { return s_TextureWidth; }
        set
        {
            s_TextureWidth = value;
            UpdateMaterial();
        }
    }

    [SerializeField]
    private Color s_Background = Color.white;
    public Color background
    {
        get { return s_Background; }
        set
        {
            s_Background = value;
            UpdateMaterial();
        }
    }

    [SerializeField]
    private Color s_CircleColor = Color.red;
    public Color circleColor
    {
        get { return s_CircleColor; }
        set { s_CircleColor = value; UpdateMaterial(); }
    }

    [SerializeField]
    private float s_BlurValue = 1.0f;
    public float blurValue
    {
        get { return s_BlurValue; }
        set { s_BlurValue = value; UpdateMaterial(); }
    }
    void UpdateMaterial()
    {
        generateTex = new Texture2D(s_TextureWidth, s_TextureWidth, TextureFormat.ARGB32, true, true);
        for (int i = 0; i < s_TextureWidth; i++)
        {
            for (int j = 0; j < s_TextureWidth; j++)
            {
                Color pixel = s_Background;
                for (int m = 1; m <= 3; m++)
                {
                    for (int n = 1; n <= 3; n++)
                    {
                        float x = (s_Radius + s_Interval) * m + 1;
                        float y = (s_Radius + s_Interval) * n + 1;
                        Vector2 center = new Vector2(x, y);
                    }
                }
                generateTex.SetPixel(i, j, pixel);
            }
        }
        generateTex.Apply();
        if (material != null)
        {
            material.SetTexture("_MainTex", generateTex);
        }
    }
    void Start()
    {
        Renderer renderer = gameObject.GetComponent<MeshRenderer>();
        material = renderer.sharedMaterial;
        // UpdateMaterial ();
        GenerateText01();
    }

    void GenerateText01()
    {
        var texture = new Texture2D(2, 2, TextureFormat.RGB24, true);
        byte[] data = {
            255,0,0,
            0,255,0,
            0,0,255,
            255,235,4,
            0,255,255,
        };
        if (texture.LoadImage(data, true))
        {
            texture.Apply(true,true);
            // AssetDatabase.CreateAsset(texture, Application.dataPath + "\test.png");
        }

    }
}